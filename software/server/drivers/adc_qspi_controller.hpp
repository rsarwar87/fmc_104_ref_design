/// DMA driver
///
/// (c) Koheron

#ifndef __DRIVERS_xQSPI_HPP__
#define __DRIVERS_xQSPI_HPP__

#include <context.hpp>

// https://www.xilinx.com/support/documentation/ip_documentation/axi_quad_spi/v3_2/pg153-axi-quad-spi.pdf 
namespace qspi_regs {
    constexpr uint32_t soft_reset = 0x40;       // soft reset
    constexpr uint32_t spi_ctrl = 0x60;  // PL Clock 0 Output control
    constexpr uint32_t spi_stat = 0x64;  // PL Clock 1 Output control
    constexpr uint32_t spi_tx = 0x68;    // OCM Software Reset Control
    constexpr uint32_t spi_rx = 0x6c;   // FPGA Software Reset Control
    constexpr uint32_t chip_sel = 0x70;         // FPGA Software Reset Control
    constexpr uint32_t spi_tx_fifo_cnt = 0x74;         // FPGA Software Reset Control
    constexpr uint32_t spi_rx_fifo_cnt = 0x78;         // FPGA Software Reset Control
    constexpr uint32_t global_int_en = 0x1c;         // FPGA Software Reset Control
    constexpr uint32_t spi_int_status = 0x20;         // FPGA Software Reset Control
    constexpr uint32_t spi_int_en = 0x28;         // FPGA Software Reset Control
}

constexpr uint32_t n_adr = 3; // Number of words in one descriptor

class xQSPI
{
  public:
    xQSPI(Context& ctx_, uint8_t c_select = 0, uint8_t c_pha = 0, uint8_t c_pol = 0)
    : ctx(ctx_)
    , spi(ctx.mm.get<mem::adc_spi>())
    {
      m_cpol = c_pol;
      m_cpha = c_pha;
      m_cselect = c_select;
    }

    inline void read_spi(uint8_t addr, uint8_t* data, bool debug = false) {
        prepare_frame(addr, data, 1, debug);
    }

    inline void write_spi(uint8_t addr, uint8_t* data, bool debug = false){
        prepare_frame(addr, data, 0, debug);
    }

    inline void sreset_spi_fifo(){
       spi.write<qspi_regs::spi_ctrl>(0x086 | (0x3 << 5));
    }

    inline void sreset_spi(){
        spi.write<qspi_regs::soft_reset>(0xa);
    }
  private:
    Context& ctx;
    Memory<mem::adc_spi>& spi;
    std::array<uint8_t, n_adr > m_buffer;
    uint8_t m_cselect;
    uint8_t m_cpha;
    uint8_t m_cpol;
    uint8_t n_bytes{4};

    inline void prepare_frame(uint16_t addr, uint8_t *data, bool read = true, bool debug = false) {
        m_buffer.at(0) = (read << 7) | (addr >> 8);
        m_buffer.at(1) = (addr & 0xFF);
        m_buffer.at(2) = 0;
        if (debug) log_buffer(read ? "Reading data"  : "Writing data");
        send_cmd();
        if (debug) log_buffer(read ? "Reading data"  : "Writing data");
        *data = m_buffer.at(2);
    }

   void send_cmd() {
       while ((spi.read<qspi_regs::spi_stat>() & 0x1) != 0x1)
         spi.read<qspi_regs::spi_rx>();

       spi.write<qspi_regs::chip_sel>(m_cselect);
       spi.write<qspi_regs::spi_ctrl>(0x086 | (m_cpol << 3) | (m_cpha << 4));

       for (int i = 0; i < n_bytes; i++) {
          spi.write<qspi_regs::spi_tx>(m_buffer.at(i));

         while ((spi.read<qspi_regs::spi_stat>() & 0x1) == 0x1)
           ;
         m_buffer.at(i) = spi.read<qspi_regs::spi_rx>() & 0xff;
       }

       spi.write<qspi_regs::chip_sel>(0xFF);
       spi.write<qspi_regs::spi_ctrl>(0x186 | (m_cpol << 3) | (m_cpha << 4));
    }

 
    inline void log_buffer(std::string str) {

        ctx.log<INFO>("DATA LOG: %s\n", str);
        uint8_t cnt = 0;
        for(const auto& s: m_buffer) 
        {
          ctx.log<INFO>("\tBuf[%d] = %d \n", cnt++, s);
        }
        ctx.log<INFO>("\n");
    }

    inline void log_spi() {
        ctx.log<INFO>("AXI_SPI REGISTERS NOT IMPLEMETNTED YET\n");
        ctx.log<INFO>("\n");
    }

} ;

#endif // __DRIVERS_ADC_DAC_DMA_HPP__
