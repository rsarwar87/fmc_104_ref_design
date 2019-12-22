#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import math
import numpy as np

from scripts.koheron import command

class TopLevelDriver(object):
    def __init__(self, client):
        self.client = client

    @command()
    def adcSpiInitialize(self):
        return self.client.recv_uint32()

    @command()
    def get_dna(self):
        return self.client.recv_uint64()
    @command()
    def get_fortytwo(self):
        return self.client.recv_uint32()

    @command(classname='ClockGenerator')
    def set_sampling_frequency(self, val):
        pass
