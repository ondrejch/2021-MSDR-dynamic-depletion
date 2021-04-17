# -*- coding: utf-8 -*-
"""
Author: Visura Pathirana

This script will create directories and write and place matlab script

"""

# import packages
import numpy as np
import os
from shutil import copyfile

#Depletion time range
depletion_range = np.linspace(0, 3650, num=101)

#EOC Percent Change 
pCp = -5

if pCp < 0:
	tag_pCp = "n"+'{:.0f}'.format(abs(pCp))
	
elif pCp >= 0:
	tag_pCp = "p"+'{:.0f}'.format(pCp)	

for i in depletion_range:

    work_path = "../depl"'{:.0f}'.format(i) 
    os.mkdir(work_path)

    depl_script = " %%MSDR Transient1 Depletion Point\n\
    \n\
    addpath('~/MSDR_with_DHnDepl/SensitivityStudy/Transient1_pCp/Sensitivity_-5/scripts')\n\
    \n\
	delChange_Cp_Fuel_EOC = "+'{:.0f}'.format(pCp)+"/100; \n\
	\n\
    depletion_time = "+'{:.0f}'.format(i)+"; \n\
    \n\
    run('Transient1.m');  %transient parameter file \n\
    \n\
    run('savedata_Transient1.m'); \n\
    \n\
    power_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+" = power_data; %saves interpolated power data \n\
    save('power_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+".mat','power_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+"') \n\
    \n\
    ext_react_results"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+" = [reacttime',react_external_dol']; \n\
    save('ext_react_results"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+".mat','ext_react_results"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+"') \n\
    \n\
    temp_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+" = temp_data; %saves interpolated temp data \n\
    save('temp_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+".mat','temp_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+"') \n\
    \n\
    react_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+" = react_data; %saves interpolated react data \n\
    save('react_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+".mat','react_data"+'{:.0f}'.format(i)+"sen_"+'{}'.format(tag_pCp)+"') \n"

    #Write depl script
    depl_file_name = "%s/depl_point_script.m" %work_path
    depl_file = open(os.path.join(work_path, depl_file_name), mode='w+')
    depl_file.write(depl_script)
    depl_file.close()
    
    COPY_FILE = "%s/run_matlab.sh" %work_path
    copyfile("run_matlab.sh", COPY_FILE)

    bashCommand1 = "chmod +x %s" % COPY_FILE
    os.system(bashCommand1)

    bashCommand2 = "cd %s && qsub run_matlab.sh" % work_path
    os.system(bashCommand2)

    bashCommand3 = "cd ~/MSDR_with_DHnDepl/SensitivityStudy/Transient1_pCp/Sensitivity_-5/scripts"
    os.system(bashCommand3)
