/// DMA driver
///
/// (c) Koheron

#ifndef __DRIVERS_ADC_DAC_DMA_HPP__
#define __DRIVERS_ADC_DAC_DMA_HPP__

#include <context.hpp>
#include <dma-sg_controller.hpp>
#include <adc_qspi_controller.hpp>
#include <fifo_controller.hpp>
// AXI DMA Registers
// https://www.xilinx.com/support/documentation/ip_documentation/axi_dma/v7_1/pg021_axi_dma.pdf
using std::unique_ptr;
class TopLevelDriver
{
  public:
    TopLevelDriver(Context& ctx_)
    : ctx(ctx_)
    , ctl(ctx.mm.get<mem::control>())
    {
        // Unlock SCLR
      qspi = std::make_unique<xQSPI>(ctx);
      ptr_dma  = std::make_unique<DMAEngineSG>(ctx);
      m_psa = std::make_unique<SSFifoController>(ctx);
    }
    
    ~TopLevelDriver()
    {
      qspi.reset();
      ptr_dma.reset();
      m_psa.reset();
    }

    void PsaFifoReset()
    {
      m_psa->reset_rx_fifo();
    }
    uint32_t PsaFifoCount()
    {
      return m_psa->get_rxfifo_length();
    }
    auto& PsaFifoCount(uint32_t n_samples)
    {
      using namespace std::chrono_literals;
      psa_buffer_vect.resize(n_samples);
      std::lock_guard<std::mutex> lock(m_psa->mutex);
      while (n_samples*4 > m_psa->get_rxfifo_length())
        std::this_thread::sleep_for(10ms);
      for (uint32_t i = 0; i < n_samples*4; i++)
        psa_buffer_vect.at(i) = m_psa->read_rx_fifo();
      return psa_buffer_vect;
    }

    void DmaSetData(const std::vector<uint32_t>& data)
    {
      ptr_dma->set_data(data);
    }
    auto& DmaGetData()
    {
      return ptr_dma->get_data();
    }
    void DmaSetCyclic_mm2s(bool enable)
    {
      ptr_dma->enable_cyclic_<Dma_regs::mm2s_dmacr, Dma_regs::mm2s_taildesc>(enable);
    }
    void DmaSetDrescriptor_mm2s()
    {
      ptr_dma->set_descriptors_<mem::ram_s2mm_addr>();
    }
    void DmaStart_mm2s(bool debug)
    {
      ptr_dma->start_dma_<mem::ram_mm2s_addr, Dma_regs::mm2s_curdesc, Dma_regs::mm2s_dmacr, Dma_regs::mm2s_taildesc, mem::ocm_mm2s_addr>(debug);
    }
    void DmaStop_mm2s()
    {
      ptr_dma->stop_dma_<Dma_regs::mm2s_dmacr, Dma_regs::mm2s_taildesc, mem::ocm_mm2s_addr>();
    }

    void qSpiResetFifo()
    {
      qspi->sreset_spi_fifo();
    }
    void qSpiReset()
    {
      qspi->sreset_spi();
    } 
    void adcSpiInitialize()
    {
      using namespace std::chrono_literals;
      qSpiWrite(0x00, 0x30); // reset clock tree
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x00, 0x10); // pull it out of reset
      std::this_thread::sleep_for(1ms);

        //set output for C
      qSpiWrite(0x3C, 0x0C);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x3D, 0x0C);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x3E, 0x0C);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x3F, 0x0C);
      std::this_thread::sleep_for(1ms);

      //enable channel 5 a
      qSpiWrite(0x40, 0x03);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x41, 0x02);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x42, 0x02);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x43, 0x03);
      std::this_thread::sleep_for(1ms);
      //set high/low cycle
      qSpiWrite(0x48, 0x21);// low[7:4] high[3:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x49, 0x00);// phase[3:0 bypass[7]]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4A, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4B, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4C, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4D, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4E, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x4F, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x50, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x51, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x52, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x53, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x54, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x55, 0x00);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x56, 0x21);
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x57, 0x00);
      std::this_thread::sleep_for(1ms);
      // global params
      qSpiWrite(0x04, 0x05); // A counter [5:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x05, 0x00); // B counter[4:0 - > 12:8]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x06, 0x0F); // B counter [7:0]
      std::this_thread::sleep_for(1ms);
      //qSpiWrite(0x07, 0xUE); // loss of ref settings
      qSpiWrite(0x08, 0x4F); // CP mode[1:0]; MUX[5:2]; PFD[6]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x09, 0x70); //[counter resets{Rn N All}[2:0]] CP curren[6:4]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x0A, (0x2 << 2)); //prescaller[4:2] Powerdown [1:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x0B, 0x00); // R divider[13:8 -> 5:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x0C, 0x10); // R divider[7:0]
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x45, 0x02); // clock power down
      std::this_thread::sleep_for(1ms);
      qSpiWrite(0x5A, 0x01); // update registers
      std::this_thread::sleep_for(1ms);
    }
    void adcClockTreeDebug()
    {
      ctx.log<INFO>("ADC CLOCKTREE LOG \n");
      ctx.log<INFO>("DMAIntErr = %8x:%8x \n", 0x0, qSpiRead(0x0));
      ctx.log<INFO>("\n");
    
    }
    void qSpiWrite(uint8_t addr, uint8_t data)
    {
      qspi->write_spi(addr, &data, false);
    }
    uint32_t qSpiRead(uint8_t addr)
    {
      uint8_t spi_ret;
      qspi->read_spi(addr, &spi_ret, false);
      return spi_ret;
    }

  private:
    Context& ctx;
    Memory<mem::control>& ctl;
    unique_ptr<xQSPI> qspi;  
    unique_ptr<SSFifoController> m_psa;  
    unique_ptr<DMAEngineSG> ptr_dma;  
    std::vector<int32_t> psa_buffer_vect;

} ;

#endif // __DRIVERS_ADC_DAC_DMA_HPP__
