#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import os
import time
from scripts.koheron import connect, command

import matplotlib
matplotlib.use('TKAgg')
from matplotlib import pyplot as plt
from matplotlib.lines import Line2D

class TopLevelDriver(object):
    def __init__(self, client):
        self.client = client
        self.n = 8*1024*1024
        self.adc0 = np.zeros((self.n/4))
        self.adc1 = np.zeros((self.n/4))
        self.adc2 = np.zeros((self.n/4))
        self.adc3 = np.zeros((self.n/4))

    @command()
    def adcSpiInitialize(self):
        pass

    @command()
    def get_dna(self):
        return self.client.recv_uint64()
    @command()
    def get_fortytwo(self):
        return self.client.recv_uint32()

    @command()
    def set_adc_clear_error(self, val):
        pass

    @command()
    def set_adc_delay_dec(self, val):
        pass

    @command()
    def set_adc_delay_inc(self, val):
        pass

    @command()
    def set_gpio(self, val):
        pass

    @command(classname="xQSPI")
    def read_spi(self, debug):
        return self.client.recv_uint32()

    @command(classname="xQSPI")
    def write_spi(self, val, debug):
        pass

    @command(classname="DmaDriver")
    def stop_dma_s2mm(self):
        pass

    def get_adc1(self):
        data = self.get_s2mm_data()
        self.adc0 = (np.int32(data[::2] % 65536) - 32768) % 65536 - 32768
        self.adc1 = (np.int32(data[::2] >> 16) - 32768) % 65536 - 32768
        self.adc2 = (np.int32(data[1::2] % 65536) - 32768) % 65536 - 32768
        self.adc3 = (np.int32(data[1::2] >> 16) - 32768) % 65536 - 32768

    @command(classname="DmaSG")
    def get_s2mm_data(self):
        return self.client.recv_array(self.n/2, dtype='uint32')

    @command(classname="DmaSG")
    def start_dma_s2mm(self):
        pass

    @command(classname="DmaSG")
    def start_dma_acquisition(self, val):
        pass
    @command(classname="DmaSG")
    def stop_dma_acquisition(self):
        pass
    @command(classname="DmaSG")
    def check_dmaacq_thread(self):
        pass
if __name__ == "__main__":
    host = os.getenv('HOST', '10.211.3.35')
    client = connect(host, 'topleveldriver', restart=False)
    driver = TopLevelDriver(client)

    print ("Print fortytwo: {}".format(driver.get_fortytwo()))
    print ("Print FPGA ID: {}".format(driver.get_dna()))

    driver.adcSpiInitialize()

    print("Get ADC data ({} points)".format(driver.n))
    driver.start_dma_s2mm()
    driver.get_s2mm_data()
    driver.stop_dma_s2mm()
    
    fs = 250e6
    t = np.arange(driver.n/4) / fs
    n_pts = 100000
    plt.plot(1e6 * t[0:n_pts], driver.adc0[0:n_pts], marker=".")
    plt.plot(1e6 * t[0:n_pts], driver.adc1[0:n_pts], marker=".")
    plt.plot(1e6 * t[0:n_pts], driver.adc2[0:n_pts], marker=".")
    plt.plot(1e6 * t[0:n_pts], driver.adc3[0:n_pts], marker=".")
    plt.legend(['ADC0', 'ADC1','ADC2', 'ADC3' ])
    plt.xlabel('Time (us)')
    plt.ylabel('ADC Raw data')
    plt.show()

