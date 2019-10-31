
#ifndef __DRIVERS_DEMODULATOR_HPP__
#define __DRIVERS_DEMODULATOR_HPP__

#include <context.hpp>

#include <array>

// http://www.xilinx.com/support/documentation/ip_documentation/axi_fifo_mm_s/v4_1/pg080-axi-fifo-mm-s.pdf
namespace Fifo_regs {
constexpr uint32_t intc_status = 0x00;
constexpr uint32_t intc_enable = 0x04;
constexpr uint32_t tx_fiforst  = 0x8;   // write 0xA5
constexpr uint32_t tx_vacancy  = 0xC;   // free spaces in fifo
constexpr uint32_t tx_buffer   = 0x10;   // tx buffer
constexpr uint32_t tx_len      = 0x14;      // number of bytes in the packet
constexpr uint32_t rx_fiforst  = 0x18;  // write 0xAf
constexpr uint32_t rx_vacancy  = 0x1C;  // free spaces in fifo
constexpr uint32_t rx_buffer   = 0x20;   // tx buffer
constexpr uint32_t rx_len      = 0x24;      // number of bytes in the packet
constexpr uint32_t ss_rst      = 0x28;      // reset ip; write 0xA5
constexpr uint32_t tx_dest     = 0x2c;
constexpr uint32_t rx_dest     = 0x30;
}

constexpr uint32_t fifo_buff_size = 8192 * 256;

class SSFifoController {
 public:
  SSFifoController(Context& _ctx)
      : ctx(_ctx), adc_fifo_map(_ctx.mm.get<mem::axi_fifo_mm_s>()) {
  }

  ~SSFifoController() {
    stop_fifo_acquisition();
  }

  inline void reset_tx_fifo() {
    adc_fifo_map.write<Fifo_regs::tx_fiforst>(0x000000A5);
  }
  inline void reset_rx_fifo() {
    adc_fifo_map.write<Fifo_regs::rx_fiforst>(0x000000A5);
  }

  inline void write_tx_fifo(int32_t val) {
    return adc_fifo_map.write<Fifo_regs::tx_buffer>(val);
  }

  inline int32_t read_rx_fifo() { 
    return adc_fifo_map.read<Fifo_regs::rx_buffer>(); 
  }

  inline uint32_t get_txfifo_length() {
    return (adc_fifo_map.read<Fifo_regs::tx_len>() & 0x3FFFFF) >> 2;
  }

  inline uint32_t get_rxfifo_length() {
    return (adc_fifo_map.read<Fifo_regs::rx_len>() & 0x3FFFFF) >> 2;
  }

  inline std::vector<int32_t>& get_vector(uint32_t n_pts = 1) {
    last_buffer_vect.resize(n_pts);
    std::lock_guard<std::mutex> lock(mutex);
    uint32_t start_idx = fifo_buff_idx - (fifo_buff_idx % 2);
    if (!fifo_circular) n_pts = start_idx;
    for (uint32_t i = 0; i < n_pts; i++) {
      last_buffer_vect[n_pts - 1 - i] =
          fifo_buffer[(start_idx - 1 - i) % fifo_buff_size];
    }
    if (!fifo_circular) fifo_buff_idx = 0;

    return last_buffer_vect;
  }

  void start_fifo_acquisition(bool circular = false);
  void stop_fifo_acquisition()
  {
    fifo_acquisition_started = false;
    fifo_thread.join();
  }
  std::mutex mutex;

 private:
  Context& ctx;
  Memory<mem::axi_fifo_mm_s>& adc_fifo_map;


  std::atomic<bool> fifo_circular{false};
  std::atomic<bool> fifo_acquisition_started{false};

  std::atomic<uint32_t> fifo_buff_idx{0};
  std::array<int32_t, fifo_buff_size> fifo_buffer;

  std::vector<int32_t> last_buffer_vect;
  std::thread fifo_thread;
  void fifo_acquisition_thread();
};

inline void SSFifoController::start_fifo_acquisition(bool circular) {
  if (!fifo_acquisition_started) {
    fifo_buffer.fill(0);
    fifo_circular = circular;
    fifo_thread = std::thread{&SSFifoController::fifo_acquisition_thread, this};
    fifo_thread.detach();
  }
}

inline void SSFifoController::fifo_acquisition_thread() {
  using namespace std::chrono_literals;
  fifo_acquisition_started = true;
  while (fifo_acquisition_started) {
    {
      std::lock_guard<std::mutex> lock(mutex);
      const uint32_t n_pts = get_rxfifo_length();
      ctx.log<INFO>("fifo_length: %d \n", n_pts);
      for (size_t i = 0; i < fifo_buff_idx; i++)
      {
        fifo_buffer[fifo_buff_idx] = read_rx_fifo();
        if ((n_pts + fifo_buff_idx < fifo_buff_size - 2) || fifo_circular) 
          fifo_buff_idx = (fifo_buff_idx + 1) % fifo_buff_size;
      }
    }
    //start a new thread
    std::this_thread::sleep_for(10ms);
  }
}


#endif  // __DRIVERS_DEMODULATOR_HPP__
