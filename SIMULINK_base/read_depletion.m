%This script read depletion data from a .txt file and create an evenly
%spaced matrix with time for depletion data

%read stored depletion data
depl_data_raw = importdata('kin_dyn_edit.txt');
% depl_data_raw = importdata('dep_test.txt');

%turn depletion raw data to a matlab array
depl_matx=depl_data_raw.data;

%set time range of depletion in depletion data
range_depl = depl_matx(1,1) : 1 : depl_matx(end,1); %time range from zero to last element [days]

depl_beta(:,1) = interp1(depl_matx(:,1),depl_matx(:,2),range_depl,'spline'); %beta 1
depl_beta(:,2) = interp1(depl_matx(:,1),depl_matx(:,3),range_depl,'spline'); %beta 2
depl_beta(:,3) = interp1(depl_matx(:,1),depl_matx(:,4),range_depl,'spline'); %beta 3
depl_beta(:,4) = interp1(depl_matx(:,1),depl_matx(:,5),range_depl,'spline'); %beta 4
depl_beta(:,5) = interp1(depl_matx(:,1),depl_matx(:,6),range_depl,'spline'); %beta 5
depl_beta(:,6) = interp1(depl_matx(:,1),depl_matx(:,7),range_depl,'spline'); %beta 6
depl_sum_beta = depl_beta(:,1)+depl_beta(:,2)+depl_beta(:,3)+depl_beta(:,4)+depl_beta(:,5)+depl_beta(:,6);
depl_Lam = interp1(depl_matx(:,1),depl_matx(:,8),range_depl,'spline').'; %LAMBDA
depl_fuel_temp_coef = interp1(depl_matx(:,1),depl_matx(:,9),range_depl,'spline').'; %fuel temp coef
depl_grap_temp_coef = interp1(depl_matx(:,1),depl_matx(:,10),range_depl,'spline').'; %grap temp coef


%% Plot depletion data 

% figure(1)
% subplot(3,1,1)
% box on
% grid on 
% hold on
% plot(1E5*depl_sum_beta,'color','#0007cf','LineWidth',1)
% plot(1E5*depl_beta(:,1),'color','#11cf00','LineWidth',1)
% plot(1E5*depl_beta(:,2),'color','#cf00ba','LineWidth',1)
% plot(1E5*depl_beta(:,3),'color','#00c5cf','LineWidth',1)
% plot(1E5*depl_beta(:,4),'color','#fc9700','LineWidth',1)
% plot(1E5*depl_beta(:,5),'color','#7e00f5','LineWidth',1)
% plot(1E5*depl_beta(:,6),'color','#fc0303','LineWidth',1)
% 
% 
% ylabel('Reactvity [pcm]')
% legend('Total','Group 1','Group 2','Group 3','Group 4','Group 5','Group 6')
% title('Delayed neutrons \beta')
% % xlim([0 3650])
% % ylim([0 700])
% 
% subplot(3,1,2)
% box on
% grid on 
% hold on
% plot(depl_Lam,'color','#fc0303','LineWidth',1)
% ylabel('Neutron generation time [s^{-1}]')
% title('Neutron generation time \Lambda')
% % xlim([0 3650])
% 
% subplot(3,1,3)
% box on
% grid on 
% hold on
% plot(depl_fuel_temp_coef,'color','#fc0303','LineWidth',1)
% plot(depl_grap_temp_coef,'color','#0f03fc','LineWidth',1)
% ylabel('Reactivity [pcm]')
% legend('\alpha_{fuel}','\alpha_{graphite}')
% title('Temperature Feedback \alpha')
% xlabel('Effective Full Power Days')
% % xlim([0 3650])
% 
% x0=10;
% y0=10;
% width=1100;
% height=1050;
% set(gcf,'position',[x0,y0,width,height])
% 
