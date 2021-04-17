# -*- coding: utf-8 -*-
"""
Author: Visura Pathirana

This script will create directories and write and place matlab script

"""

# import packages
import numpy as np
import os
import sys
from shutil import copyfile

depletion_range = np.linspace(0, 3650, num=101)

DepletionTime = []
minPowerVal = []
timeToRecrit = []
maxPowerVal = []
timeToMaxPower = []
inTempMax = []
outTempMax = []
avgTempGrapMax = []
inTempMin = []
outTempMin = []
avgTempGrapMin = []
react_fb_tot_pcmMax = []
react_fb_f_pcmMax = []
react_fb_g_pcmMax = []

for i in depletion_range:
	
	work_path = "../depl"'{:.0f}'.format(i)
	result_file = "%s/sim_results_Transient3.txt" %work_path
	line_dat = np.genfromtxt(result_file, delimiter = ',')
	DepletionTime.append(line_dat[0])
	minPowerVal.append(line_dat[1])
	timeToRecrit.append(line_dat[2])
	maxPowerVal.append(line_dat[3])
	timeToMaxPower.append(line_dat[4])
	inTempMax.append(line_dat[5])
	outTempMax.append(line_dat[6])
	avgTempGrapMax.append(line_dat[7])
	inTempMin.append(line_dat[8])
	outTempMin.append(line_dat[9])
	avgTempGrapMin.append(line_dat[10])
	react_fb_tot_pcmMax.append(line_dat[11])
	react_fb_f_pcmMax.append(line_dat[12])
	react_fb_g_pcmMax.append(line_dat[13])

	if i == 0 or i == 1825 or i == 3650:
		power_results = "power_data"+'{:.0f}'.format(i)+".mat"
		temp_results = "temp_data"+'{:.0f}'.format(i)+".mat"
		react_results = "react_data"+'{:.0f}'.format(i)+".mat"
		ext_react_results = "ext_react_results"+'{:.0f}'.format(i)+".mat"

		powerCopy = "cp "+ work_path + "/" + power_results + " ../scripts/results" 
		os.system(powerCopy)
		
		tempCopy = "cp "+ work_path + "/" + temp_results + " ../scripts/results" 
		os.system(tempCopy)

		reactCopy = "cp "+ work_path + "/" + react_results + " ../scripts/results" 
		os.system(reactCopy)
		
		extreactCopy = "cp "+ work_path + "/" + ext_react_results + " ../scripts/results" 
		os.system(extreactCopy)		

orig_stdout = sys.stdout
output_file  = open('all_depl_results_Transient3.m', 'w+')
sys.stdout = output_file

print('depletion_time =', DepletionTime,';\n')
print('minPowerVal = ', minPowerVal,';\n')
print('timeToRecrit = ', timeToRecrit,';\n')
print('maxPowerVal = ', maxPowerVal,';\n')
print('timeToMaxPower = ', timeToMaxPower,';\n')
print('inTempMax = ', inTempMax,';\n')
print('outTempMax = ', outTempMax,';\n')
print('avgTempGrapMax = ', avgTempGrapMax,';\n')
print('inTempMin = ', inTempMin,';\n')
print('outTempMin = ', outTempMin,';\n')
print('avgTempGrapMin = ', avgTempGrapMin,';\n')
print('react_fb_tot_pcmMax = ', react_fb_tot_pcmMax,';\n')
print('react_fb_f_pcmMax = ', react_fb_f_pcmMax,';\n')
print('react_fb_g_pcmMax = ', react_fb_g_pcmMax,';\n')

sys.stdout = orig_stdout
output_file.close()
