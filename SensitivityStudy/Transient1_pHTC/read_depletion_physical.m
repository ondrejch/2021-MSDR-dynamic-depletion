%%Depletion denpendent physical property change factor calculations
%%Authors: Visura Pathirana
%%Supervisors: Dr. Ondrej Chvala

%% User Inputs

%Density change delage EOC
delChange_den_Fuel_EOC = 0;
delChange_den_Grp_EOC = 0; 
delChange_den_FLiBe_EOC = 0; 
delChange_den_hAlloy_EOC = 0; 
delChange_den_HITEC_EOC = 0; 

%Specific Heat Capacity change delage EOC
delChange_Cp_Fuel_EOC = 0;
delChange_Cp_Grp_EOC = 0;
delChange_Cp_FLiBe_EOC = 0; 
delChange_Cp_hAlloy_EOC = 0;
delChange_Cp_HITEC_EOC = 0;

%Heat Transfer Coef. change delage EOC
%delChange_h_core_EOC = 0; 
%delChange_h_pPHX_EOC = 0; 
delChange_h_sPHX_EOC = 0; 
delChange_h_pSHX_EOC = 0;
delChange_h_sSHX_EOC = 0;

%Assuming a linear realtionship similar to depl_X_X_coef = gradient * -
%-depletion + 1

den_Fuel_grad = (delChange_den_Fuel_EOC)/range_depl(end);
den_Grp_grad = (delChange_den_Grp_EOC)/range_depl(end);
den_FLiBe_grad = (delChange_den_FLiBe_EOC)/range_depl(end);
den_hAlloy_grad = (delChange_den_hAlloy_EOC)/range_depl(end);
den_HITEC_grad = (delChange_den_HITEC_EOC)/range_depl(end);

Cp_Fuel_grad = (delChange_Cp_Fuel_EOC)/range_depl(end);
Cp_Grp_grad = (delChange_Cp_Grp_EOC)/range_depl(end);
Cp_FLiBe_grad = (delChange_Cp_FLiBe_EOC)/range_depl(end);
Cp_hAlloy_grad = (delChange_Cp_hAlloy_EOC)/range_depl(end);
Cp_HITEC_grad = (delChange_Cp_HITEC_EOC)/range_depl(end);

h_core_coef_grad = (delChange_h_core_EOC)/range_depl(end);
h_pPHX_coef_grad = (delChange_h_pPHX_EOC)/range_depl(end);
h_sPHX_coef_grad = (delChange_h_sPHX_EOC)/range_depl(end);
h_pSHX_coef_grad = (delChange_h_pSHX_EOC)/range_depl(end);
h_sSHX_coef_grad = (delChange_h_sSHX_EOC)/range_depl(end);

%Densities
depl_den_Fuel_coef = (den_Fuel_grad*depletion_time) +1; %correction factor for fuel density
depl_den_Grp_coef = (den_Grp_grad*depletion_time) +1; %correction factor for graphite density
depl_den_FLiBe_coef = (den_FLiBe_grad*depletion_time) +1; %correction factor for FLiBe density
depl_den_hAlloy_coef = (den_hAlloy_grad*depletion_time) +1; %correction factor for tube density
depl_den_HITEC_coef = (den_HITEC_grad*depletion_time) +1; %correction factor for HITEC density

%Specific Heat Capaities
depl_Cp_Fuel_coef = (Cp_Fuel_grad*depletion_time) +1; %correction factor for fuel specific heat capacity
depl_Cp_Grp_coef = (Cp_Grp_grad*depletion_time) +1; %correction factor for graphite specific heat capacity
depl_Cp_FLiBe_coef = (Cp_FLiBe_grad*depletion_time) +1; %correction factor for FLiBe specific heat capacity
depl_Cp_hAlloy_coef = (Cp_hAlloy_grad*depletion_time) +1; %correction factor for tube specific heat capacity 
depl_Cp_HITEC_coef = (Cp_HITEC_grad*depletion_time) +1; %correction factor for HITEC specific heat capacity


%Heat Transfer Coefficents
depl_h_core_coef = (h_core_coef_grad*depletion_time) +1; %correction factor for fuel:graphite heat transfer coef (core)
depl_h_pPHX_coef = (h_pPHX_coef_grad*depletion_time) +1; %correction factor for fuel:tube heat transfer coef (primary side PHX)
depl_h_sPHX_coef = (h_sPHX_coef_grad*depletion_time) +1; %correction factor for tube:FLiBe heat transfer coef (secondary side PHX)
depl_h_pSHX_coef = (h_pSHX_coef_grad*depletion_time) +1; %correction factor for FLiBe:tube heat transfer coef (primary side SHX)
depl_h_sSHX_coef = (h_sSHX_coef_grad*depletion_time) +1; %correction factor for tube:HITEC heat transfer coef (secondary side SHX)
