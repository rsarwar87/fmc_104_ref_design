/// DMA driver
///
/// (c) Koheron

#ifndef __DRIVERS_ADC_DAC_DMA_HPP__
#define __DRIVERS_ADC_DAC_DMA_HPP__

#include <PracticalSocket.hpp>
#include <context.hpp>

// AXI DMA Registers
// https://www.xilinx.com/support/documentation/ip_documentation/axi_dma/v7_1/pg021_axi_dma.pdf
namespace Dma_regs {
constexpr uint32_t mm2s_dmacr = 0x0;  // MM2S DMA Control register
constexpr uint32_t mm2s_dmasr = 0x4;  // MM2S DMA Status register
constexpr uint32_t mm2s_curdesc =
    0x8;  // MM2S DMA Current Descriptor Pointer register
constexpr uint32_t mm2s_taildesc =
    0x10;  // MM2S DMA Tail Descriptor Pointer register

constexpr uint32_t s2mm_dmacr = 0x30;  // S2MM DMA Control register
constexpr uint32_t s2mm_dmasr = 0x34;  // S2MM DMA Status register
constexpr uint32_t s2mm_curdesc =
    0x38;  // S2MM DMA Current Descriptor Pointer register
constexpr uint32_t s2mm_taildesc =
    0x40;  // S2MM DMA Tail Descriptor Pointer register
}  // namespace Dma_regs

// Scatter Gather Descriptor
namespace Sg_regs {
constexpr uint32_t nxtdesc = 0x0;         // Next Descriptor Pointer
constexpr uint32_t buffer_address = 0x8;  // Buffer address
constexpr uint32_t control = 0x18;        // Control
constexpr uint32_t status = 0x1C;         // Status
}  // namespace Sg_regs

// System Level Control Registers
// https://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf
namespace Sclr_regs {
constexpr uint32_t sclr_unlock = 0x8;       // SLCR Write Protection Unlock
constexpr uint32_t fpga0_clk_ctrl = 0x170;  // PL Clock 0 Output control
constexpr uint32_t fpga1_clk_ctrl = 0x180;  // PL Clock 1 Output control
constexpr uint32_t ocm_rst_ctrl = 0x238;    // OCM Software Reset Control
constexpr uint32_t fpga_rst_ctrl = 0x240;   // FPGA Software Reset Control
constexpr uint32_t ocm_cfg = 0x910;         // FPGA Software Reset Control
}  // namespace Sclr_regs

constexpr uint32_t n_pts = 64 * 1024;  // Number of words in one descriptor
constexpr uint32_t n_desc = 64;        // Number of descriptors

class DmaSG {
 public:
  DmaSG(Context& ctx_)
     : ctx(ctx_),
        ctl(ctx.mm.get<mem::control>()),
        dma(ctx.mm.get<mem::dma>()),
        ram_s2mm(ctx.mm.get<mem::ram_s2mm>()),
        ram_mm2s(ctx.mm.get<mem::ram_mm2s>()),
        axi_hp0(ctx.mm.get<mem::axi_hp0>()),
        axi_hp2(ctx.mm.get<mem::axi_hp2>()),
        ocm_s2mm(ctx.mm.get<mem::ocm_s2mm>()),
        ocm_mm2s(ctx.mm.get<mem::ocm_mm2s>()),
        sclr(ctx.mm.get<mem::sclr>()) {
    // Unlock SCLR
    sclr.write<Sclr_regs::sclr_unlock>(0xDF0D);
    sclr.clear_bit<Sclr_regs::fpga_rst_ctrl, 1>();

    // Make sure that the width of the AXI HP port is 64 bit.
    axi_hp0.clear_bit<0x0, 0>();
    axi_hp0.clear_bit<0x14, 0>();
    axi_hp2.clear_bit<0x0, 0>();
    axi_hp2.clear_bit<0x14, 0>();

    // Map the last 64 kB of OCM RAM to the high address space
    sclr.write<Sclr_regs::ocm_cfg>(0b1000);

    for (uint32_t i = 0; i < n_pts * n_desc; i++) {
      ram_s2mm.write_reg(4 * i, 0);
      ram_mm2s.write_reg(4 * i, 0);
    }
    log_hp0();
    log_hp2();
    servAddress = "10.211.3.16";
    servPort = Socket::resolveService("8200", "udp");
  }

  void set_server_info(std::string sAddress, std::string sPort) {
    servAddress = sAddress;
    servPort = Socket::resolveService(sPort, "udp");
  };

  void set_descriptor_s2mm(uint32_t idx, uint32_t buffer_address,
                             uint32_t buffer_length) {
    ocm_s2mm.write_reg(0x40 * idx + Sg_regs::nxtdesc,
                         mem::ocm_s2mm_addr + 0x40 * ((idx + 1) % n_desc));
    ocm_s2mm.write_reg(0x40 * idx + Sg_regs::buffer_address, buffer_address);
    ocm_s2mm.write_reg(0x40 * idx + Sg_regs::control, buffer_length);
    ocm_s2mm.write_reg(0x40 * idx + Sg_regs::status, 0);
  }

  void set_descriptor_mm2s(uint32_t idx, uint32_t buffer_address,
                             uint32_t buffer_length) {
    ocm_mm2s.write_reg(0x40 * idx + Sg_regs::nxtdesc,
                         mem::ocm_mm2s_addr + 0x40 * ((idx + 1) % n_desc));
    ocm_mm2s.write_reg(0x40 * idx + Sg_regs::buffer_address, buffer_address);
    ocm_mm2s.write_reg(0x40 * idx + Sg_regs::control, buffer_length);
    ocm_mm2s.write_reg(0x40 * idx + Sg_regs::status, 0);
  }

  void start_dma_s2mm() {
    if (!dma_acquisition_started) {
      for (uint32_t i = 0; i < n_pts * n_desc; i++) {
        ram_s2mm.write_reg(4 * i, 0);
      }
    } else if (dma_acquisition_started & !dma_internal_call) {
      ctx.log<INFO>(
          "DMA::start_dma_acquisition: Thread already started, ignoring "
          "command");
      return;
    }
    for (uint32_t i = 0; i < n_desc; i++)
      set_descriptor_s2mm(i, mem::ram_s2mm_addr + i * 4 * n_pts, 4 * n_pts);
    // Write address of the starting descriptor
    // dma_0.write<Dma_regs::mm2s_curdesc>(mem::ocm_mm2s_addr + 0x0);
    dma.write<Dma_regs::s2mm_curdesc>(mem::ocm_s2mm_addr + 0x0);
    // Set DMA to cyclic mode
    // dma.set_bit<Dma_regs::s2mm_dmacr, 4>();
    // Start S2MM channel
    // dma_0.set_bit<Dma_regs::mm2s_dmacr, 0>();
    dma.set_bit<Dma_regs::s2mm_dmacr, 0>();
    // Write address of the tail descriptor
    // dma.write<Dma_regs::s2mm_taildesc>(0x50);
    // dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_s2mm1_addr + (n_desc-1) *
    // 0x40);
    dma.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm_addr +
                                         (n_desc - 1) * 0x40);
    if (!dma_acquisition_started) 
      log_dma();
  }

  void stop_dma_s2mm() {
    if (dma_acquisition_started) {
      ctx.log<INFO>(
          "DMA::stop_dma_s2mm: Thread already started, ignoring "
          "command");
      return;
    }
    // dma_0.clear_bit<Dma_regs::mm2s_dmacr, 0>();
    dma.clear_bit<Dma_regs::s2mm_dmacr, 0>();
    // dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_mm2s_addr + (n_desc-1) *
    // 0x40);
    dma.write<Dma_regs::s2mm_taildesc>(mem::ocm_s2mm_addr +
                                         (n_desc - 1) * 0x40);
  }

  void start_dma_mm2s() {
    if (dma_acquisition_started) {
      ctx.log<INFO>(
          "DMA::start_dma_mm2s: Acq Thread already started, ignoring "
          "command");
      return;
    }
    for (uint32_t i = 0; i < n_pts * n_desc; i++) {
      ram_mm2s.write_reg(4 * i, 0);
    }
    for (uint32_t i = 0; i < n_desc; i++)
      set_descriptor_mm2s(i, mem::ram_mm2s_addr + i * 4 * n_pts, 4 * n_pts);
    // Write address of the starting descriptor
    // dma_0.write<Dma_regs::mm2s_curdesc>(mem::ocm_mm2s_addr + 0x0);
    dma.write<Dma_regs::mm2s_curdesc>(mem::ocm_mm2s_addr + 0x0);
    // Set DMA to cyclic mode
    // dma.set_bit<Dma_regs::s2mm_dmacr, 4>();
    // Start S2MM channel
    // dma_0.set_bit<Dma_regs::mm2s_dmacr, 0>();
    dma.set_bit<Dma_regs::mm2s_dmacr, 0>();
    // Write address of the tail descriptor
    // dma.write<Dma_regs::s2mm_taildesc>(0x50);
    // dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_s2mm1_addr + (n_desc-1) *
    // 0x40);
    dma.write<Dma_regs::s2mm_taildesc>(mem::ocm_mm2s_addr +
                                         (n_desc - 1) * 0x40);

    log_dma();
  }

  void stop_dma_mm2s() {
    if (dma_acquisition_started) {
      ctx.log<INFO>(
          "DMA::stop_dma_1: AcqThread already started, ignoring "
          "command");
      return;
    }
    // dma_0.clear_bit<Dma_regs::mm2s_dmacr, 0>();
    dma.clear_bit<Dma_regs::mm2s_dmacr, 0>();
    // dma_0.write<Dma_regs::mm2s_taildesc>(mem::ocm_mm2s_addr + (n_desc-1) *
    // 0x40);
    dma.write<Dma_regs::mm2s_taildesc>(mem::ocm_mm2s_addr +
                                         (n_desc - 1) * 0x40);
  }
   void set_mm2s_data(const std::vector<uint32_t>& dac_data) {
           for (uint32_t i = 0; i < dac_data.size(); i++) {
                       ram_mm2s.write_reg(4*i, dac_data[i]);
                   }
       }

  auto& get_s2mm_data() {
    if (dma_acquisition_started) {
      ctx.log<INFO>(
          "DMA::get_adc0_data: Acq thread already started, ignoring "
          "command");
      return data;
    }
    using namespace std::chrono_literals;
    auto start = std::chrono::high_resolution_clock::now();
    while (ocm_s2mm.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 31>() ==
           0) {
      std::this_thread::sleep_for(10ms);
    }
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> elapsed = end - start;
    ctx.log<INFO>("DMA::get_data:: completed after %6.6f msec \n",
                  elapsed.count());
    data = ram_s2mm.read_array<uint32_t, n_desc * n_pts>();
    return data;
  }

  void start_dma_acquisition(bool circular /*, bool streaming*/) {
    if (!dma_acquisition_started) {
      dma_circular = circular;
      dma_thread = std::thread{&DmaSG::dma_acquisition_thread, this};
      dma_thread.detach();
      // streaming_thread =
      //    std::thread{&SSFifoController::stream_data_thread, this};
      // streaming_thread.detach();
    } else
      ctx.log<INFO>(
          "DMA::start_dma_acquisition: Thread already started, ignoring "
          "command");
  }
  void stop_dma_acquisition() {
    if (!dma_acquisition_started) return;
    dma_acquisition_started = false;
    // fifo_thread.join();
  }
  uint32_t check_dmaacq_thread() {
    if (dma_acquisition_started)
      return 1;
    else
      return 0;
  }

  void print_dma_log() { log_dma(); };

 private:
  Context& ctx;
  Memory<mem::control>& ctl;
  Memory<mem::dma>& dma;
  Memory<mem::ram_s2mm>& ram_s2mm;
  Memory<mem::ram_mm2s>& ram_mm2s;
  Memory<mem::axi_hp0>& axi_hp0;
  Memory<mem::axi_hp2>& axi_hp2;
  Memory<mem::ocm_s2mm>& ocm_s2mm;
  Memory<mem::ocm_mm2s>& ocm_mm2s;
  Memory<mem::sclr>& sclr;

  std::array<uint32_t, PACK_SIZE> encoded;
  std::array<uint32_t, n_desc * n_pts> data;
  std::atomic<bool> dma_acquisition_started{false};
  std::atomic<bool> dma_circular{false};
  std::atomic<bool> dma_internal_call{false};
  uint32_t ibuf[1];
  std::thread dma_thread;

  short unsigned int servPort;
  std::string servAddress;
  UDPSocket sock;

  void dma_acquisition_thread() {
    ctx.log<INFO>("DMA::DMA acqquisition thread started. \n");
    dma_acquisition_started = true;
    while (dma_acquisition_started) {
      dma_internal_call = true;
      start_dma_s2mm();
      dma_internal_call = false;
      stream_data();
    }
    ctx.log<INFO>("DMA::DMA acqquisition thread terminated. \n");
  }
  void stream_data() {
    using namespace std::chrono_literals;
    auto start = std::chrono::high_resolution_clock::now();

    constexpr uint32_t total_pack = (n_desc * n_pts) / PACK_SIZE;
    constexpr uint32_t total_pack_rem =
        ((n_desc * n_pts) / PACK_SIZE) % PACK_SIZE;
    uint16_t idx = 0;
    ibuf[0] = total_pack + 1;
    /*ctx.log<INFO>("DMA::DMA streaming data: starting... %d pkt + %d\n",
                  total_pack, total_pack_rem);*/

    std::this_thread::sleep_for(5ms);
    sock.sendTo(ibuf, sizeof(uint32_t), servAddress, servPort);

    for (size_t i = 0; i < total_pack; i++) {
      if (PACK_SIZE * i > (idx + 1) * n_pts) {
        idx++;
        /*ctx.log<INFO>("DMA::DMA streaming data: starting... %d pkt + %d\n", i,
                      idx);*/
      }
      while (ocm_s2mm.read_bit_reg(0x40 * idx + Sg_regs::status, 31) == 0)
        std::this_thread::sleep_for(5us);

      encoded = ram_s2mm.read_reg_array<uint32_t, PACK_SIZE>(i * PACK_SIZE);
      sock.sendTo(&encoded[0], PACK_SIZE, servAddress, servPort);
    }
/*    ctx.log<INFO>("DMA::DMA streaming data: starting last\n");*/
    while (ocm_s2mm.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 31>() ==
           0)
      std::this_thread::sleep_for(5us);
    auto encoded_ = ram_s2mm.read_reg_array<uint32_t, total_pack_rem>(
        total_pack * PACK_SIZE);
    sock.sendTo(&encoded_[0], total_pack_rem, servAddress, servPort);

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> elapsed = end - start;
    ctx.log<INFO>("DMA::DMA streaming data completed in = %6.6f \n", total_pack,
                  elapsed.count());
  };
  void log_dma() {
    ctx.log<INFO>("S2MM_0 LOG========================================== \n");
    ctx.log<INFO>("DMAHalted = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 0>());
    ctx.log<INFO>("DMAIdle = %d \n", dma.read_bit<Dma_regs::s2mm_dmasr, 1>());
    ctx.log<INFO>("DMASDInc = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 3>());
    ctx.log<INFO>("DMAIntErr = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 4>());
    ctx.log<INFO>("DMASlvErr = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 5>());
    ctx.log<INFO>("DMADecErr = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 6>());
    ctx.log<INFO>("SGIntErr = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 8>());
    ctx.log<INFO>("SGlvErr = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 9>());
    ctx.log<INFO>("SGDecErr = %d \n",
                  dma.read_bit<Dma_regs::s2mm_dmasr, 10>());
    ctx.log<INFO>(
        "CURDESC = %u \n",
        (dma.read<Dma_regs::s2mm_curdesc>() - mem::ocm_s2mm_addr) / 0x40);
    ctx.log<INFO>("====================================================\n");

    ctx.log<INFO>(
        "S2MM_1_STATUS DMAIntErr = %d \n",
        ocm_s2mm.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 28>());
    ctx.log<INFO>(
        "S2MM_1_STATUS DMASlvErr = %d \n",
        ocm_s2mm.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 29>());
    ctx.log<INFO>(
        "S2MM_1_STATUS DMADecErr = %d \n",
        ocm_s2mm.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 30>());
    ctx.log<INFO>(
        "S2MM_1_STATUS Cmplt = %d \n",
        ocm_s2mm.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 31>());
    ctx.log<INFO>("\n");
    ctx.log<INFO>(
        "S2MM_0_STATUS DMAIntErr = %d \n",
        ocm_mm2s.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 28>());
    ctx.log<INFO>(
        "S2MM_0_STATUS DMASlvErr = %d \n",
        ocm_mm2s.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 29>());
    ctx.log<INFO>(
        "S2MM_0_STATUS DMADecErr = %d \n",
        ocm_mm2s.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 30>());
    ctx.log<INFO>(
        "S2MM_0_STATUS Cmplt = %d \n",
        ocm_mm2s.read_bit<0x40 * (n_desc - 1) + Sg_regs::status, 31>());
    ctx.log<INFO>("====================================================\n");
  }

  void log_hp2() {
    ctx.log<INFO>("AXI_HP2 LOG \n");
    ctx.log<INFO>("AFI_WRCHAN_CTRL = %x \n", axi_hp2.read<0x14>());
    ctx.log<INFO>("AFI_WRCHAN_ISSUINGCAP = %x \n", axi_hp2.read<0x18>());
    ctx.log<INFO>("AFI_WRQOS = %x \n", axi_hp2.read<0x1C>());
    ctx.log<INFO>("AFI_WRDATAFIFO_LEVEL = %x \n", axi_hp2.read<0x20>());
    ctx.log<INFO>("AFI_WRDEBUG = %x \n", axi_hp2.read<0x24>());
    ctx.log<INFO>("\n");
  }
  void log_hp0() {
    ctx.log<INFO>("AXI_HP0 LOG \n");
    ctx.log<INFO>("AFI_WRCHAN_CTRL = %x \n", axi_hp0.read<0x14>());
    ctx.log<INFO>("AFI_WRCHAN_ISSUINGCAP = %x \n", axi_hp0.read<0x18>());
    ctx.log<INFO>("AFI_WRQOS = %x \n", axi_hp0.read<0x1C>());
    ctx.log<INFO>("AFI_WRDATAFIFO_LEVEL = %x \n", axi_hp0.read<0x20>());
    ctx.log<INFO>("AFI_WRDEBUG = %x \n", axi_hp0.read<0x24>());
    ctx.log<INFO>("\n");
  }
};

#endif  // __DRIVERS_ADC_DAC_DMA_HPP__
