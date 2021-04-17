%% Post processing UHX drop results

% set time offsets 
% interpolate simulation results 
% extract interesting parameters 

%% Set time offset values and make transient time range
timeoffset = 1750;
%timeCutoff = 2300;
timeCutoff = tout(end);

tout = tout - timeoffset;
time_capture = timeCutoff - timeoffset;

timeOffsetIndex = find(tout==0);
timeCutoffIndex = find(tout==time_capture);

time = tout(timeOffsetIndex:timeCutoffIndex);
time_range = (0 : 0.01 : time_capture).';


%% Interpolate power data & extract results
power_nom_fission = core_ht(timeOffsetIndex:timeCutoffIndex,1);
power_nom_decay = core_ht(timeOffsetIndex:timeCutoffIndex,11);
power_nom_total = power_nom_fission + power_nom_decay;

power_data(:,1) = time_range;
power_data(:,2) = interp1(time,power_nom_total,time_range,'linear');
power_data(:,3) = interp1(time,power_nom_fission,time_range,'linear');
power_data(:,4) = interp1(time,power_nom_decay,time_range,'linear');

[minPowerVal, timeToRecritIndex] = min(power_data(:,2));
timeToRecrit = time_range(timeToRecritIndex)-250;
[maxPowerVal,timeMaxPowerIndex] = max(power_data(timeToRecritIndex:end,2));
timeToMaxPower = time_range(timeMaxPowerIndex);
timeRecritToMaxPower = timeToMaxPower - timeToRecrit;

power_results = [minPowerVal, timeToRecrit, maxPowerVal, timeToMaxPower];

%% Extract and interpolate temprature data

temp_core_in = core_ht(timeOffsetIndex:timeCutoffIndex,2);
temp_core_out = core_ht(timeOffsetIndex:timeCutoffIndex,7);
temp_core_avg = (temp_core_in + temp_core_out)/2;
temp_core_avg_grap = (core_ht(timeOffsetIndex:timeCutoffIndex,5) + core_ht(timeOffsetIndex:timeCutoffIndex,8))/2;

temp_data(:,1) = time_range;
temp_data(:,2) = interp1(time,temp_core_avg,time_range,'linear');
temp_data(:,3) = interp1(time,temp_core_in,time_range,'linear');
temp_data(:,4) = interp1(time,temp_core_out,time_range,'linear');
temp_data(:,5) = interp1(time,temp_core_avg_grap,time_range,'linear');

[avgTempMax,avgTempMax_index] = max(temp_data(:,2));
avgTempMax_time = time_range(avgTempMax_index);

[inTempMax,inTempMax_index] = max(temp_data(:,3));
inTempMax_time = time_range(inTempMax_index);

[outTempMax,outTempMax_index] = max(temp_data(:,4));
outTempMax_time = time_range(outTempMax_index);

[avgTempGrapMax,avgTempGrapMax_index] = max(temp_data(:,5));
avgTempGrapMax_time = time_range(avgTempGrapMax_index);

[avgTempMin,avgTempMin_index] = min(temp_data(:,2));
avgTempMin_time = time_range(avgTempMin_index);

[inTempMin,inTempMin_index] = min(temp_data(:,3));
inTempMin_time = time_range(inTempMin_index);

[outTempMin,outTempMin_index] = min(temp_data(:,4));
outTempMin_time = time_range(outTempMin_index);

[avgTempGrapMin,avgTempGrapMin_index] = min(temp_data(:,5));
avgTempGrapMin_time = time_range(avgTempGrapMin_index);

temp_results = [inTempMax, outTempMax, avgTempGrapMax, inTempMin, outTempMin, avgTempGrapMin];

%% Extract and interpolate reactivity data 

rho_fb_tot_pcm = rho_fb_tot*1E5;
rho_fb_f_pcm = rho_fb_f*1E5;
rho_fb_g_pcm = rho_fb_g*1E5;
rho_tot_pcm = core_react*1E5;

rho_fb_tot_offset_pcm = rho_fb_tot_pcm(timeOffsetIndex);
rho_fb_f_offset_pcm = rho_fb_f_pcm(timeOffsetIndex);
rho_fb_g_offset_pcm = rho_fb_g_pcm(timeOffsetIndex);
rho_tot_offset_pcm = rho_tot_pcm(timeOffsetIndex);

react_fb_tot_pcm = rho_fb_tot_pcm(timeOffsetIndex:timeCutoffIndex) - rho_fb_tot_offset_pcm;
react_fb_f_pcm = rho_fb_f_pcm(timeOffsetIndex:timeCutoffIndex) - rho_fb_f_offset_pcm;
react_fb_g_pcm = rho_fb_g_pcm(timeOffsetIndex:timeCutoffIndex) - rho_fb_g_offset_pcm;
react_tot_pcm = rho_tot_pcm(timeOffsetIndex:timeCutoffIndex) - rho_tot_offset_pcm; 
%react_external_pcm = rho_external(timeoffset:timeCutoff);
reacttime = reacttime - timeoffset;
react_external_dol = reactdata/rho_0;

react_data(:,1) = time_range;
react_data(:,2) = interp1(time,react_fb_tot_pcm,time_range,'linear');
react_data(:,3) = interp1(time,react_fb_f_pcm,time_range,'linear');
react_data(:,4) = interp1(time,react_fb_g_pcm,time_range,'linear');
react_data(:,5) = interp1(time,react_tot_pcm,time_range,'linear');
%react_data(:,6) = interp1(time,react_external_pcm,time_range,'linear');

[react_fb_tot_pcmMin,react_fb_tot_pcmMin_index] = min(react_data(:,2));
react_fb_tot_pcmMax_time = time_range(react_fb_tot_pcmMin_index);

[react_fb_f_pcmMin,react_fb_f_pcmMin_index] = min(react_data(:,3));
react_fb_f_pcmMax_time = time_range(react_fb_f_pcmMin_index);

[react_fb_g_pcmMin,react_fb_g_pcmMin_index] = min(react_data(:,4));
react_fb_g_pcmMax_time = time_range(react_fb_g_pcmMin_index);

[react_tot_pcmMin,react_tot_pcmMin_index] = min(react_data(:,5));
react_tot_pcmMax_time = time_range(react_tot_pcmMin_index);

react_results = [react_fb_tot_pcmMin, react_fb_f_pcmMin, react_fb_g_pcmMin];

%% Save data and results 

sim_results = [depletion_time,power_results,temp_results,react_results];
writematrix(sim_results,'sim_results_Transient2.txt');
type sim_results_Transient2.txt