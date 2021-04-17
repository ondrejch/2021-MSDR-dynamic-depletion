%% Plot MSDR Depletion Results
run('all_depl_results_Transient3.m')

load('power_data0.mat');
load('power_data1825.mat');
load('power_data3650.mat');

load('temp_data0.mat');
load('temp_data1825.mat');
load('temp_data3650.mat');

load('react_data0.mat');
load('react_data1825.mat');
load('react_data3650.mat');

timecut = 10000;
timeOffSet = 500;

figure(1)
subplot(3,1,1)
box on
grid on 
hold on
plot(power_data0(:,1) - timeOffSet,power_data0(:,2),'red')
plot(power_data1825(:,1) - timeOffSet,power_data1825(:,2),'blue')
plot(power_data3650(:,1) - timeOffSet,power_data3650(:,2),'green')
ylabel('Nominal Power')
legend('BOC','Mid Cycle (5 years)', 'EOC (10 years)')
title('Reactor Power')
xlim([-500 timecut]) 
ylim([0 1.05])

axes('Position',[.7 .7 .2 .2])
box on
grid on 
hold on
plot(power_data0(:,1) - timeOffSet,power_data0(:,2),'red')
plot(power_data1825(:,1) - timeOffSet,power_data1825(:,2),'blue')
plot(power_data3650(:,1) - timeOffSet,power_data3650(:,2),'green')
ylabel('Nominal Power')
xlabel('time [s]')
xlim([7000 9000]) 
ylim([0 0.1])

subplot(3,1,2)
box on
grid on 
hold on
plot(temp_data0(:,1) - timeOffSet,temp_data0(:,2),'red')
plot(temp_data1825(:,1) - timeOffSet,temp_data1825(:,2),'blue')
plot(temp_data3650(:,1) - timeOffSet,temp_data3650(:,2),'green')
ylabel('Temperature [C]')
title('Core Avg. Fuel Temperatures')
xlim([-500 timecut]) 
% ylim([-inf inf])

subplot(3,1,3)
box on
grid on 
hold on
plot(react_data0(:,1) - timeOffSet,react_data0(:,2),'red')
plot(react_data1825(:,1) - timeOffSet,react_data1825(:,2),'blue')
plot(react_data3650(:,1) - timeOffSet,react_data3650(:,2),'green')
ylabel('Reactivity [pcm]')
xlabel('Time [s]')
title('Total Temperature Feedback')
xlim([-500 timecut])
ylim([0 1550])

x0=10;
y0=10;
width=1100;
height=1050;
set(gcf,'position',[x0,y0,width,height])

figure(2)
subplot(4,1,1)
box on
grid on 
hold on
yyaxis left
ylabel('Max Nominal Power')
plot(depletion_time,smooth(maxPowerVal))
yyaxis right
ylabel('Time to Recriticality [s]')
plot(depletion_time,timeToRecrit)
title('Maximum Reactor Power Post Recriticality & Time to Recriticality')
xlim([0 3650])
ylim([-inf inf])

subplot(4,1,2)
box on
grid on 
hold on
yyaxis left
ylabel('Max Coldleg Temp [C]')
plot(depletion_time,inTempMax)
yyaxis right
ylabel('Min Coldleg Temp [C]')
plot(depletion_time,inTempMin)
title('Maximum & Minimum Coldleg Temperatures')
xlim([0 3650])
ylim([-inf inf])

subplot(4,1,3)
box on
grid on 
hold on
yyaxis left
ylabel('Max Hotleg Temp [C]')
plot(depletion_time,outTempMax)
yyaxis right
ylabel('Min Hotleg Temp [C]')
plot(depletion_time,outTempMin)
title('Maximum & Minimum Hotleg Temperatures')
xlim([0 3650])
ylim([-inf inf])

subplot(4,1,4)
box on
grid on 
hold on 
yyaxis left
ylabel('Max Avg. Graphite Temp [C]')
plot(depletion_time,avgTempGrapMax)
yyaxis right
ylabel('Min Avg. Graphite Temp [C]')
plot(depletion_time,avgTempGrapMin)
title('Maximum & Minimum Avg. Graphite Temperatures')
xlabel('Effective Full Power Days')
xlim([0 3650])
ylim([-inf inf])

x0=10;
y0=10;
width=1100;
height=1050;
set(gcf,'position',[x0,y0,width,height])


