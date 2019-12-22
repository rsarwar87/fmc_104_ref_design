#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import os
import time
from adc_dac_bram import TopLevelDriver
from scripts.koheron import connect

import matplotlib
matplotlib.use('TKAgg')
from matplotlib import pyplot as plt
from matplotlib.lines import Line2D

host = os.getenv('HOST', '10.211.3.35')
client = connect(host, 'topleveldriver', restart=False)
driver = TopLevelDriver(client)

print driver.get_fortytwo()

