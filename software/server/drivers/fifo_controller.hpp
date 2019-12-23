
#ifndef __DRIVERS_DEMODULATOR_HPP__
#define __DRIVERS_DEMODULATOR_HPP__

#include <context.hpp>

#include <PracticalSocket.hpp>
#include <array>
#include <container.hpp>

// http://www.xilinx.com/support/documentation/ip_documentation/axi_fifo_mm_s/v4_1/pg080-axi-fifo-mm-s.pdf
namespace Fifo_regs {
constexpr uint32_t intc_status = 0x00;
constexpr uint32_t intc_enable = 0x04;
constexpr uint32_t tx_fiforst = 0x8;   // write 0xA5
constexpr uint32_t tx_vacancy = 0xC;   // free spaces in fifo
constexpr uint32_t tx_buffer = 0x10;   // tx buffer
constexpr uint32_t tx_len = 0x14;      // number of bytes in the packet
constexpr uint32_t rx_fiforst = 0x18;  // write 0xAf
constexpr uint32_t rx_vacancy = 0x1C;  // free spaces in fifo
constexpr uint32_t rx_buffer = 0x20;   // tx buffer
constexpr uint32_t rx_len = 0x24;      // number of bytes in the packet
constexpr uint32_t ss_rst = 0x28;      // reset ip; write 0xA5
constexpr uint32_t tx_dest = 0x2c;
constexpr uint32_t rx_dest = 0x30;
}  // namespace Fifo_regs

constexpr uint32_t fifo_buff_size = 8192 * 256;

class SSFifoController {
 public:
  SSFifoController(Context& _ctx)
      : ctx(_ctx), adc_fifo_map(_ctx.mm.get<mem::axi_fifo_mm_s>()) {
    servAddress = "10.211.3.16";
    servPort = Socket::resolveService("7200", "udp");
  }

  ~SSFifoController() { stop_fifo_acquisition(); }

  void set_server_info(std::string sAddress, std::string sPort)
  {
      servAddress = sAddress;
      servPort = Socket::resolveService(sPort, "udp");
  };

  void fifo_reset_tx() {
    adc_fifo_map.write<Fifo_regs::tx_fiforst>(0x000000A5);
  }
  void fifo_reset_rx() {
    adc_fifo_map.write<Fifo_regs::rx_fiforst>(0x000000A5);
  }

  void fifo_write_tx(int32_t val) {
    return adc_fifo_map.write<Fifo_regs::tx_buffer>(val);
  }

  uint32_t fifo_read_rx() { return adc_fifo_map.read<Fifo_regs::rx_buffer>(); }

  uint32_t fifo_vacancy_tx() {
    return (adc_fifo_map.read<Fifo_regs::tx_vacancy>() & 0x7FFFFF);
  }

  uint32_t fifo_vacancy_rx() {
    return (adc_fifo_map.read<Fifo_regs::rx_vacancy>() & 0x7FFFFF);
  }

  auto& get_vector_rx(/*uint32_t n_pts*/) {
    // last_buffer_vect.resize(n_pts);
    uint32_t n_pts = 2048;
    if (!fifo_acquisition_started) {
      ctx.log<INFO>("FIFO::get_vector_rx:: Thread not started, ignoring command");
      return last_buffer_vect;
    }
    using namespace std::chrono_literals;
    while (fifo_sending_udp) std::this_thread::sleep_for(10ms);

    fifo_get_request = true;
    while (fifo_buffer.size() < n_pts) {
      
        ctx.log<INFO>("get_vector_rx:: Fifo get request, waiting at: %d \n",
                     fifo_buffer.size());
       
      std::this_thread::sleep_for(10ms);
    }
    auto start = std::chrono::high_resolution_clock::now();
    std::lock_guard<std::mutex> lock(mutex);
    ctx.log<INFO>("FIFO::get_vector_rx:: No of words found: %d \n",
                  fifo_buffer.size());
    for (size_t i = 0; i < n_pts; i++)
      last_buffer_vect.at(i) = fifo_buffer.pop_front();
    fifo_get_request = false;
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> elapsed = end-start;
    ctx.log<INFO>("FIFO::get_vector_rx:: Left with %d after %6.6f msec \n",
                  fifo_buffer.size(),elapsed.count());

    return last_buffer_vect;
  }

  void start_fifo_acquisition(bool circular /*, bool streaming*/) {
    if (!fifo_acquisition_started) {
      fifo_buffer.fill(0);
      fifo_circular = circular;
      fifo_thread =
          std::thread{&SSFifoController::fifo_acquisition_thread, this};
      fifo_thread.detach();
      // streaming_thread =
      //    std::thread{&SSFifoController::stream_data_thread, this};
      // streaming_thread.detach();
    } else
      ctx.log<INFO>(
          "FIFO::start_fifo_acquisition: Thread already started, ignoring command");
  }
  void stop_fifo_acquisition() {
    if (!fifo_acquisition_started) return;
    fifo_acquisition_started = false;
    // fifo_thread.join();
  }
  uint32_t check_fifoacq_thread() {
    if (fifo_acquisition_started)
      return 1;
    else
      return 0;
  }
  std::mutex mutex;

 private:
  Context& ctx;
  Memory<mem::axi_fifo_mm_s>& adc_fifo_map;

  std::atomic<bool> fifo_circular{false};
  std::atomic<bool> fifo_sending_udp{false};
  std::atomic<bool> fifo_get_request{false};
  std::atomic<bool> fifo_started_streaming{false};
  std::atomic<bool> fifo_acquisition_started{false};

  CyclicArray<uint32_t, fifo_buff_size> fifo_buffer;

  std::array<uint32_t, 2048> last_buffer_vect;
  std::thread fifo_thread;
  std::thread streaming_thread;

  short unsigned int servPort;
  std::string servAddress;
  std::array<uint32_t, PACK_SIZE> encoded;
  UDPSocket sock;

  void fifo_acquisition_thread() {
    using namespace std::chrono_literals;
    fifo_acquisition_started = true;
    ctx.log<INFO>("FIFO:: Started acq thread\n");
    while (fifo_acquisition_started) {
      {
        std::lock_guard<std::mutex> lock(mutex);
        const uint32_t n_pts = fifo_vacancy_rx();
        if (n_pts > 100 &&
            (fifo_circular || (fifo_buffer.size() < fifo_buff_size - 1)))
          //ctx.log<INFO>("fifo thread found %d points\n", n_pts);
          for (size_t i = 0; i < n_pts; i++) {
            fifo_buffer.push_back(fifo_read_rx());
          }
        // ctx.log<INFO>("fifo thread has %d new points\n", fifo_vacancy_rx());
      }
      // start a new thread
      if (fifo_buffer.size() > PACK_SIZE * 2)
        stream_data();
      else
        std::this_thread::sleep_for(10ms);
    }
    ctx.log<INFO>("FIFO:: Terminated acq thread\n");
  };


  void stream_data() {
    if (fifo_get_request) return;
    using namespace std::chrono_literals;
    fifo_sending_udp = true;
    std::lock_guard<std::mutex> lock(mutex);
    auto start = std::chrono::high_resolution_clock::now();
    uint32_t total_pack = (fifo_buffer.size() - 1) / PACK_SIZE;
    uint32_t ibuf[1];
    ibuf[0] = total_pack;
    ctx.log<INFO>("FIFO::stream_data; NPkt = %d; Size = %d \n", total_pack,
                  fifo_buffer.size());

    sock.sendTo(ibuf, sizeof(uint32_t), servAddress, servPort);

    for (size_t i = 0; i < total_pack; i++) {
      for (size_t j = 0; j < PACK_SIZE; j++)
        encoded[j] = fifo_buffer.pop_front();
      sock.sendTo(&encoded[0], PACK_SIZE, servAddress, servPort);
    }

    fifo_sending_udp = false;
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> elapsed = end-start;
    ctx.log<INFO>("FIFO::stream_data; NPkt = %d; Duration = %6.6f \n", total_pack,
                  elapsed.count());

    std::this_thread::sleep_for(5ms);
  };

};

#endif  // __DRIVERS_DEMODULATOR_HPP__
