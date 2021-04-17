% %% Plot MSDR Depletion Results

run('all_depl_results_BaseCase.m')
run('all_pCp_sen5_depl_results_Transient1.m')
run('all_pCp_sen10_depl_results_Transient1.m')
run('all_pCp_sen25_depl_results_Transient1.m')
run('all_pCp_sen50_depl_results_Transient1.m')
run('all_pCp_senN5_depl_results_Transient1.m')
run('all_pCp_senN10_depl_results_Transient1.m')
run('all_pCp_senN25_depl_results_Transient1.m')
run('all_pCp_senN50_depl_results_Transient1.m')

load('power_data0.mat');
load('power_data3650sen_p5.mat');
load('power_data3650sen_p10.mat');
load('power_data3650sen_p25.mat');
load('power_data3650sen_p50.mat');
load('power_data3650sen_n5.mat');
load('power_data3650sen_n10.mat');
load('power_data3650sen_n25.mat');
load('power_data3650sen_n50.mat');
load('power_data3650.mat');

load('temp_data0.mat');
load('temp_data3650sen_p5.mat');
load('temp_data3650sen_p10.mat');
load('temp_data3650sen_p25.mat');
load('temp_data3650sen_p50.mat');
load('temp_data3650sen_n5.mat');
load('temp_data3650sen_n10.mat');
load('temp_data3650sen_n25.mat');
load('temp_data3650sen_n50.mat');
load('temp_data3650.mat');

load('react_data0.mat');
load('react_data3650sen_p5.mat');
load('react_data3650sen_p10.mat');
load('react_data3650sen_p25.mat');
load('react_data3650sen_p50.mat');
load('react_data3650sen_n5.mat');
load('react_data3650sen_n10.mat');
load('react_data3650sen_n25.mat');
load('react_data3650sen_n50.mat');
load('react_data3650.mat');

load('ext_react_results0.mat');
load('ext_react_results3650sen_p5.mat');
load('ext_react_results3650sen_p10.mat');
load('ext_react_results3650sen_p25.mat');
load('ext_react_results3650sen_p50.mat');
load('ext_react_results3650sen_n5.mat');
load('ext_react_results3650sen_n10.mat');
load('ext_react_results3650sen_n25.mat');
load('ext_react_results3650sen_n50.mat');
load('ext_react_results3650.mat');


timecut = 80;
timeOffSet = 50;

figure(1)
subplot(3,1,1)
box on
grid on 
hold on
plot(power_data0(:,1) - timeOffSet,power_data0(:,2),'color','#FF0000','LineWidth',2)
plot(power_data3650(:,1) - timeOffSet,power_data3650(:,2),'color','#000000','LineWidth',2)
plot(power_data3650sen_p5(:,1) - timeOffSet,power_data3650sen_p5(:,2),'color','#EDB120','LineStyle','--','LineWidth',2)
plot(power_data3650sen_p10(:,1) - timeOffSet,power_data3650sen_p10(:,2),'color','#FF00FF','LineStyle','--','LineWidth',2)
plot(power_data3650sen_p25(:,1) - timeOffSet,power_data3650sen_p25(:,2),'color','#00FF00','LineStyle','--','LineWidth',2)
plot(power_data3650sen_p50(:,1) - timeOffSet,power_data3650sen_p50(:,2),'color','#0000FF','LineStyle','--','LineWidth',2)
plot(power_data3650sen_n5(:,1) - timeOffSet,power_data3650sen_n5(:,2),'color','#EDB120','LineStyle',':','LineWidth',2)
plot(power_data3650sen_n10(:,1) - timeOffSet,power_data3650sen_n10(:,2),'color','#FF00FF','LineStyle',':','LineWidth',2)
plot(power_data3650sen_n25(:,1) - timeOffSet,power_data3650sen_n25(:,2),'color','#00FF00','LineStyle',':','LineWidth',2)
plot(power_data3650sen_n50(:,1) - timeOffSet,power_data3650sen_n50(:,2),'color','#0000FF','LineStyle',':','LineWidth',2)
ylim([0.95 1.5])
ylabel('Nominal Power')
yyaxis right
plot(ext_react_results0(:,1) - timeOffSet,ext_react_results0(:,2),'color','#FF0000','LineStyle','--')
plot(ext_react_results3650(:,1) - timeOffSet,ext_react_results3650(:,2),'color','#000000','LineStyle','--')
ylabel('Reactvity Inserted [$]')
legend('BOC', 'Normal EOC', '+5% pCp @ EOC', '+10% pCp @ EOC', '+25% pCp @ EOC', '+50% pCp @ EOC', '-5% pCp @ EOC', '-10% pCp @ EOC', '-25% pCp @ EOC', '-50% pCp @ EOC','BOC Reactivity','EOC Reactivity')
title('Reactor Power & External Reactivity')
xlim([-10 timecut]) 
ylim([0 1.4])

subplot(3,1,2)
box on
grid on 
hold on
plot(temp_data0(:,1) - timeOffSet,temp_data0(:,2),'color','#FF0000','LineWidth',2)
plot(temp_data3650sen_p5(:,1) - timeOffSet,temp_data3650sen_p5(:,2),'color','#EDB120','LineStyle','--','LineWidth',2)
plot(temp_data3650sen_p10(:,1) - timeOffSet,temp_data3650sen_p10(:,2),'color','#FF00FF','LineStyle','--','LineWidth',2)
plot(temp_data3650sen_p25(:,1) - timeOffSet,temp_data3650sen_p25(:,2),'color','#00FF00','LineStyle','--','LineWidth',2)
plot(temp_data3650sen_p50(:,1) - timeOffSet,temp_data3650sen_p50(:,2),'color','#0000FF','LineStyle','--','LineWidth',2)
plot(temp_data3650sen_n5(:,1) - timeOffSet,temp_data3650sen_n5(:,2),'color','#EDB120','LineStyle',':','LineWidth',2)
plot(temp_data3650sen_n10(:,1) - timeOffSet,temp_data3650sen_n10(:,2),'color','#FF00FF','LineStyle',':','LineWidth',2)
plot(temp_data3650sen_n25(:,1) - timeOffSet,temp_data3650sen_n25(:,2),'color','#00FF00','LineStyle',':','LineWidth',2)
plot(temp_data3650sen_n50(:,1) - timeOffSet,temp_data3650sen_n50(:,2),'color','#0000FF','LineStyle',':','LineWidth',2)
plot(temp_data3650(:,1) - timeOffSet,temp_data3650(:,2),'color','#000000','LineWidth',2)
ylabel('Temprature [C]')
title('Core Avg. Fuel Temperatures')
xlim([-10 timecut]) 
ylim([-inf inf])

subplot(3,1,3)
box on
grid on 
hold on
plot(react_data0(:,1) - timeOffSet,react_data0(:,2),'color','#FF0000','LineWidth',2)
plot(react_data3650sen_p5(:,1) - timeOffSet,react_data3650sen_p5(:,2),'color','#EDB120','LineStyle','--','LineWidth',2)
plot(react_data3650sen_p10(:,1) - timeOffSet,react_data3650sen_p10(:,2),'color','#FF00FF','LineStyle','--','LineWidth',2)
plot(react_data3650sen_p25(:,1) - timeOffSet,react_data3650sen_p25(:,2),'color','#00FF00','LineStyle','--','LineWidth',2)
plot(react_data3650sen_p50(:,1) - timeOffSet,react_data3650sen_p50(:,2),'color','#0000FF','LineStyle','--','LineWidth',2)
plot(react_data3650sen_n5(:,1) - timeOffSet,react_data3650sen_n5(:,2),'color','#EDB120','LineStyle',':','LineWidth',2)
plot(react_data3650sen_n10(:,1) - timeOffSet,react_data3650sen_n10(:,2),'color','#FF00FF','LineStyle',':','LineWidth',2)
plot(react_data3650sen_n25(:,1) - timeOffSet,react_data3650sen_n25(:,2),'color','#00FF00','LineStyle',':','LineWidth',2)
plot(react_data3650sen_n50(:,1) - timeOffSet,react_data3650sen_n50(:,2),'color','#0000FF','LineStyle',':','LineWidth',2)
plot(react_data3650(:,1) - timeOffSet,react_data3650(:,2),'color','#000000','LineWidth',2)
ylabel('Reactivity [pcm]')
xlabel('Time [s]')
title('Total Temperature Feedback')
xlim([-10 timecut])
ylim([-120 10])

x0=10;
y0=10;
width=1100;
height=1050;
set(gcf,'position',[x0,y0,width,height])




figure(2)
subplot(3,1,1)
box on
grid on
hold on
yyaxis left
plot(depletion_time,maxPowerVal,'-','LineWidth',1)
% plot(depletion_time_p5,maxPowerVal_p5,'color','#EDB120','LineStyle','--','LineWidth',1)
% plot(depletion_time_p10,maxPowerVal_p10,'color','#FF00FF','LineStyle','--','LineWidth',1)
plot(depletion_time_p25,maxPowerVal_p25,'--','LineWidth',1)
plot(depletion_time_p50,maxPowerVal_p50,':','LineWidth',2)
% plot(depletion_time_n5,maxPowerVal_n5,'color','#EDB120','LineStyle',':','LineWidth',1)
% plot(depletion_time_n10,maxPowerVal_n10,'color','#FF00FF','LineStyle',':','LineWidth',1)
plot(depletion_time_n25,maxPowerVal_n25,'-.','LineWidth',2)
plot(depletion_time_n50,maxPowerVal_n50,'-x','LineWidth',1)

ylabel('Nominal Power')
yyaxis right
plot(depletion_time,FWHM,'-','LineWidth',1)
% plot(depletion_time_p5,FWHM_p5,'color','#EDB120','LineStyle','--','LineWidth',1)
% plot(depletion_time_p10,FWHM_p10,'color','#FF00FF','LineStyle','--','LineWidth',1)
plot(depletion_time_p25,FWHM_p25,'--','LineWidth',1)
plot(depletion_time_p50,FWHM_p50,':','LineWidth',2)
% plot(depletion_time_n5,FWHM_n5,'color','#EDB120','LineStyle',':','LineWidth',1)
% plot(depletion_time_n10,FWHM_n10,'color','#FF00FF','LineStyle',':','LineWidth',1)
plot(depletion_time_n25,FWHM_n25,'-.','LineWidth',2)
plot(depletion_time_n50,FWHM_n50,'-x','LineWidth',1)

ylabel('FWHM [s]')
title('Maximum Reactor Power & FWHM')
% legend('Normal','+5% pCp', '+10% pCp', '+25% pCp', '+50% pCp', '-5% pCp', '-10% pCp', '-25% pCp', '-50% pCp')
legend('Normal', '+25% pCp', '+50% pCp', '-25% pCp', '-50% pCp')
xlim([0 3650])
ylim([-inf inf])

subplot(3,1,2)
box on
grid on
hold on
yyaxis left
plot(depletion_time,avgTempMax,'-','LineWidth',1)
% plot(depletion_time_p5,avgTempMax_p5,'-+')
% plot(depletion_time_p10,avgTempMax_p10,'-*')
plot(depletion_time_p25,avgTempMax_p25,'--','LineWidth',1)
plot(depletion_time_p50,avgTempMax_p50,':','LineWidth',2)
% plot(depletion_time_n5,avgTempMax_n5,'-s')
% plot(depletion_time_n10,avgTempMax_n10,'-d')
plot(depletion_time_n25,avgTempMax_n25,'-.','LineWidth',2)
plot(depletion_time_n50,avgTempMax_n50,'-x','LineWidth',1)
ylabel('Avg. Fuel Temperatures [C]')
yyaxis right
plot(depletion_time,avgTempGrapMax,'-','LineWidth',1)
% plot(depletion_time_p5,avgTempGrapMax_p5,'-+')
% plot(depletion_time_p10,avgTempGrapMax_p10,'-*')
plot(depletion_time_p25,avgTempGrapMax_p25,'--','LineWidth',1)
plot(depletion_time_p50,avgTempGrapMax_p50,':','LineWidth',2)
% plot(depletion_time_n5,avgTempGrapMax_n5,'-s')
% plot(depletion_time_n10,avgTempGrapMax_n10,'-d')
plot(depletion_time_n25,avgTempGrapMax_n25,'-.','LineWidth',2)
plot(depletion_time_n50,avgTempGrapMax_n50,'-x','LineWidth',1)
ylabel('Avg. Graphite Temperatures [C]')
title('Maximum Core Temperatures')
xlim([0 3650])
ylim([-inf inf])

subplot(3,1,3)
box on
grid on 
hold on 
yyaxis left
plot(depletion_time,react_fb_f_pcmMax,'-','LineWidth',1)
% plot(depletion_time_p5,react_fb_f_pcmMax_p5,'-+')
% plot(depletion_time_p10,react_fb_f_pcmMax_p10,'-*')
plot(depletion_time_p25,react_fb_f_pcmMax_p25','--','LineWidth',1)
plot(depletion_time_p50,react_fb_f_pcmMax_p50',':','LineWidth',2)
% plot(depletion_time_n5,react_fb_f_pcmMax_n5,'-s')
% plot(depletion_time_n10,react_fb_f_pcmMax_n10,'-d')
plot(depletion_time_n25,react_fb_f_pcmMax_n25,'-.','LineWidth',2)
plot(depletion_time_n50,react_fb_f_pcmMax_n50,'-x','LineWidth',1)
ylabel('Fuel Feedback [pcm]')
yyaxis right
plot(depletion_time,react_fb_g_pcmMax,'-','LineWidth',1)
% plot(depletion_time_p5,react_fb_g_pcmMax_p5,'-+')
% plot(depletion_time_p10,react_fb_g_pcmMax_p10,'-*')
plot(depletion_time_p25,react_fb_g_pcmMax_p25,'--','LineWidth',1)
plot(depletion_time_p50,react_fb_g_pcmMax_p50,':','LineWidth',2)
% plot(depletion_time_n5,react_fb_g_pcmMax_n5,'-s')
% plot(depletion_time_n10,react_fb_g_pcmMax_n10,'-d')
plot(depletion_time_n25,react_fb_g_pcmMax_n25,'-.','LineWidth',2)
plot(depletion_time_n50,react_fb_g_pcmMax_n50,'-x','LineWidth',1)
ylabel('Graphite Feedback [pcm]')
xlabel('Effective Full Power Days')
title('Minimum Temperature Feedbacks')
xlim([0 3650])
ylim([-inf inf])

x0=10;
y0=10;
width=1100;
height=1050;
set(gcf,'position',[x0,y0,width,height])