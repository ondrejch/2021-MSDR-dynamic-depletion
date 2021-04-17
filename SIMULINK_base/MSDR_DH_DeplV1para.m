%%% MSDR with Decay Heat & Depletion
%%% Author: Visura Pathirana
%%% Building on work done by Vikram Sinha and Alex Wheeler
%%% Project advisor - Dr. Ondrej Chvala

%% Simulation Parameter File
%%% This script calculate and initialize simulation parameters
%%% User inputs are listed in the User Input section
%%% Advised to leave user inputs commented to avoid conflicts
%%% Advised to create a script using included example transient files as a template

%% User Inputs Start

% %%% Basic Simulation Parameters
% P=750;                                                                       %Operational thermal power [MW]
% simtime = 5000;                                                            %Simulation time [s]
% ts_max = 1e-1;                                                             %Maximum timestep [s] 
% rel_tolerance = 1e-5;                                                      %Relatve tolerance
% 
% %% Fuel Type
% %%% fuel_type = 235; for FLibe with U235 (MSDR)
% %%% fuel_type = 233; for FLiBe with U233 (MSRE)
% %%% fuel_type = 123; for FLiBe with U235 with depletion accounting (MSDR)
% fuel_type = 235;   
% 
% %%% Only for fuel_type = 123;
% depletion_time = 3650;                                                        %Depletion point [days]
% 
% %% External Reactivity Insertions & Sinusoidal Reactvity Insertions 
% reactdata = [0 0 0];                                                       %Reactivity insertions [abs]
% reacttime = [0 1000 1005];                                                 %Reactivity insertion time [s]
% react = timeseries(reactdata,reacttime);                                   %Defining source timeseries
% 
% omega          = 10.00000;                                                 %Frequncy of the sine wave [rad]
% sin_mag        = 0;                                                        %Amplitude of the sine wave [abs]
% dx             = round((2*pi/omega)/25, 2, 'significant');                 %Size of the time step [s]
% 
% %% Pump Trips
% 
% %%% Primary Pump Set
% Trip_P1_pump = 2000000;                                                    %Time at which primary pump 1 is tripped [s]
% Trip_P2_pump = 2000000;                                                    %Time at which primary pump 2 is tripped [s]
% Trip_P3_pump = 2000000;                                                    %Time at which primary pump 3 is tripped [s]
% 
% %%% Secondary Pump Set
% Trip_S1_pump = 2000000;                                                    %Time at which secondary pump 1 is tripped [s]
% Trip_S2_pump = 2000000;                                                    %Time at which secondary pump 2 is tripped [s]
% Trip_S3_pump = 2000000;                                                    %Time at which secondary pump 3 is tripped [s]
% 
% %%% Tertiary Pump Set
% Trip_T1_pump = 2000000;                                                    %Time at which tertiary pump 1 is tripped [s]
% Trip_T2_pump = 2000000;                                                    %Time at which tertiary pump 2 is tripped [s]
% Trip_T3_pump = 2000000;                                                    %Time at which tertiary pump 3 is tripped [s]
% 
% %% UHX Parameters
% %%% UHX_MODE = 1; uses an Once Through Steam Generator
% %%% UHX_MODE = 2; uses a constant power removal block
% %%% Both modes allow instant trip and demand follow
% UHX_MODE = 1;
% Trip_UHX = 2000000;                                                        %Time at which ultimate heat exchanger is tripped [s]
% 
% demanddata = [1 1 1];                                                      %Reactivity insertions [abs]
% demandtime = [0 2000 simtime];                                             %Reactivity insertion time [s]
% demand = timeseries(demanddata,demandtime);                                %Defining source timeseries                              %Defining source timeseries
% 
% %% DHRS Parameters
% %%% DHRS_MODE = 1; a sigmoid based DHRS (Normal DHRS)
% %%% DHRS_MODE = 2; a square pulse based DHRS (Broken DHRS)
% %%% DHRS_MODE = 1; allows modifications to sigmoid behavior using parameters with Normal DHRS in parameter file
% %%% DHRS_MODE = 2; allows cold slug insertions
% DHRS_MODE = 1; 
% DHRS_time=20000000;                                                        %Time at which DRACS will be activated [s]
% 
% %%% Only for DHRS_MODE = 1
% DHRS_Power= P*(0.10);                                                      %Maximum power that can be removed by DHRS
% Power_Bleed= P*(0.00);                                                     %Some power can be removed from DRACS even when its not activated 
% 
% %%% Only for DHRS_MODE = 2
% SlugDeltaTemp = 30;                                                        %Temperature drop by broken DHRS [deg. C]
% Slug_duration = 10;                                                        %Duration of slug [s]
%% User Input End


%% Model Parameters Start

%% Required functions 

% % Add path to required files
% OSTG_func = '/SIMULINK_base/OSTG_functions';
% depl_func = '/SIMULINK_base/Depletion_functions';
% 
% addpath(strcat(pwd,OSTG_func))
% addpath(strcat(pwd,depl_func))

% Run required files
run('read_depletion.m');
run('read_depletion_physical.m');

%% Core heat transfer parameters
core_height = 6.8; % (m), Source: ORNL-3832, table 9
core_radius = 3.4; % (m), Source: ORNL-3832, table 9
core_fuel_frac = 0.1; % Source: ORNL-3832, table 9

core_volume = pi*(core_radius)^2*core_height; %(m3) 

core_fuelvol = 0.1*core_volume;

% fuel salt density
den_f   = depl_den_Fuel_coef*3355.95; % fuel salt density as calc. using empirical eqn. 236.3-(2.33e-2*T(deg-F)), (kg/m3), Source: Source: ORNL-TM-3832, table 3
den_g   = depl_den_Grp_coef*1860; % density of graphite (kg/m3) same as MSRE, Source: ORNL-TM-0728, table 5.3

mass_fuel = core_fuelvol*den_f; % (kg)
mass_fn = mass_fuel/4;
mass_graphite = (core_volume - core_fuelvol)*den_g; % (kg)
mass_gn = mass_graphite/4;

% fuel salt specific heat capacity, Source: ORNL-TM-4676, table 3.1
Cp_f    = depl_Cp_Fuel_coef*1.355616e-3; % (MJ/kg/�C)

% graphite specific heat capacity, Source: Same as MSRE
Cp_g    = depl_Cp_Grp_coef*1.773e-3; % (MJ/kg/�C)

% nodal masses in core
mfa     = [mass_fn, mass_fn]; % fuel nodes a
mfb     = [mass_fn, mass_fn]; % fuel nodes b
mg      = [mass_gn, mass_gn]; % graphite nodes

% heat deposition fractions, adopted from MSRE
ka       = [0.235, 0.235]; % power generation fraction for fuel nodes a
kb       = [0.235, 0.235]; % power generation fraction for fuel nodes b
kga      = [0.015, 0.015]; % heat transferred from for graphite node to fuel node a
kgb      = [0.015, 0.015]; % heat transferred from for graphite node to fuel node b

% (mass)*(specific heat capacity)
mcp_fa   = mfa*Cp_f;
mcp_fb   = mfb*Cp_f;
mcp_g    = mg*Cp_g; 

% (heat transfer coefficient)*(area) for fuel/graphite interfaces 
h_fg     = depl_h_core_coef*1.8e-4; % (MW/m2/�C)
A_fg     = 8979; % (m2)
hA_fg    = [h_fg*A_fg/2, h_fg*A_fg/2]; 

% Importance factors for core nodes
Ifa      = [0.25, 0.25]; % fuel nodes a
Ifb      = [0.25, 0.25]; % fuel nodes b
Ig       = [0.5, 0.5]; % graphite nodes

% initial temperatures (�C)
% Fuel volumes
core_fv = core_fuelvol; % volume of fuel in the core (m3), Source: ORNL-TM-3832, table 9
pipe_fv = 9.0614; % volume of fuel in external piping and PHX (m3), Source: ORNL-TM-3832, table 9
tot_fv  = core_fuelvol+pipe_fv; % total volume of fuel salt in the plant (m3), Source: ORNL-TM-3832, table 9

% Fuel temperature in core
Tf_out  = 695.4813           ; % core fuel salt outlet temperature (�C), Source: ORNL-TM-3832, fig 1 & table 2
Tf_in   = 584.5972           ; % core fuel salt inlet temperature (�C), Source: ORNL-TM-3832, fig 1 & table 2
Tf_avg  = (Tf_out + Tf_in)/2; % core fuel salt avg temperature, (out+in)/2

T0_fa    = [612.3182, 667.7603]; % fuel nodes a
T0_fb    = [640.0393, Tf_out]; % fuel nodes b
T0_g     = [640.1610, 695.6031]; % graphite nodes

%% PKE tau calculations
% mass of fuel salt
core_fm = core_fuelvol*den_f     ; % mass of fuel in core (kg)
pipe_fm = pipe_fv*den_f     ; % mass of fuel in external pipes and PHX (kg)

% fuel salt flow rate
W_f     = 4989.48          ; % fuel salt flow rate (kg/s)

W_f1    = W_f/3;
W_f2    = W_f/3;
W_f3    = W_f/3;

m_fm    = W_f*1; 

% Source: ORNL-TM-3832, table 2, and Source: ORNL-4676 table 3.2, lists parameters for a 150 MW(th) HX, there
% are six of these in the MSDR for a total of 750 MW(th)

% PKE taus
tau_c   = core_fm/W_f; % fuel salt core residence time (s)
tau_l   = pipe_fm/W_f; % fuel salt loop residence time (s)

%% PKE parameters
n0      = 1; % initial fractional neutron density

%%%U-235 data
if fuel_type == 235
    Lam  = 2.400E-04;  %Mean generation time {ORNL-TM-1070 p.15 for U235}
    lam  = [1.240E-02, 3.05E-02, 1.11E-01, 3.01E-01, 1.140E+00, 3.014E+00];
    beta = [0.000223,0.001457,0.001307,0.002628,0.000766,0.00023]; % U235
    a_f     = -3.22E-5          ; % total fuel salt thermal reactivity coefficient (drho/�C)
    a_g     = +2.35E-5          ; % total graphite thermal reactivity coefficient (drho/�C)
end

%%%U-233 data for MSRE
if fuel_type == 233
    Lam    = 4.0E-04;  % mean generation time ORNL-TM-1070 p.15 U233
    lam    = [1.260E-02, 3.370E-02, 1.390E-01, 3.250E-01, 1.130E+00, 2.500E+00]; %U233
    beta   = [0.00023,0.00079,0.00067,0.00073,0.00013,0.00009]; % U233
    a_f    = -11.034E-5; % U233 (drho/°C) fuel salt temperature-reactivity feedback coefficient ORNL-TM-1647 p.3 % -5.904E-05; % ORNL-TM-0728 p. 101 %
    a_g    = -05.814E-5; % U233  (drho/°C) graphite temperature-reactivity feedback coefficient ORNL-TM-1647 p.3 % -6.624E-05; % ORNL-TM-0728 p.101
end

%%%U-235 data with depletion
if fuel_type == 123
    depl_index = find(range_depl  == depletion_time);
    Lam    = depl_Lam(depl_index);
    lam    = [1.240E-02, 3.05E-02, 1.11E-01, 3.01E-01, 1.140E+00, 3.014E+00];
    beta   = depl_beta(depl_index,:);
    a_f    = 1E-5*depl_fuel_temp_coef(depl_index);
    a_g    = 1E-5*depl_grap_temp_coef(depl_index);

end 

beta_t  = sum(beta)         ; % total delayed-neutron yield (abs frac)

bterm     = 0;
for i = 1:6
    bterm = bterm + beta(i)/(1.0 + ((1.0-exp(-lam(i)*tau_l))/(lam(i)*tau_c)));
end 
rho_0     = beta_t - bterm;

% initial fractional delayed-neutron densities for groups 1..6
C0(1)   = ((beta(1))/Lam)*(1.0/(lam(1) - (exp(-lam(1)*tau_l) - 1.0)/tau_c));
C0(2)   = ((beta(2))/Lam)*(1.0/(lam(2) - (exp(-lam(2)*tau_l) - 1.0)/tau_c));
C0(3)   = ((beta(3))/Lam)*(1.0/(lam(3) - (exp(-lam(3)*tau_l) - 1.0)/tau_c));
C0(4)   = ((beta(4))/Lam)*(1.0/(lam(4) - (exp(-lam(4)*tau_l) - 1.0)/tau_c));
C0(5)   = ((beta(5))/Lam)*(1.0/(lam(5) - (exp(-lam(5)*tau_l) - 1.0)/tau_c));
C0(6)   = ((beta(6))/Lam)*(1.0/(lam(6) - (exp(-lam(6)*tau_l) - 1.0)/tau_c));

%% HX PARAMETERS
%% PHX heat transfer parameters

Wp_phx1   =  831.58            ; % primary fluid mass flow rate in PHX, 1/6 of primary flow rate, table 2 ORNL-TM-3832 (kg/s)
Wp_phx2   =  831.58            ;
Wp_phx3   =  831.58            ;
Wp_phx4   =  831.58            ;
Wp_phx5   =  831.58            ;
Wp_phx6   =  831.58            ;

mp_phxm   = (Wp_phx1 + Wp_phx2)*1; % mass in the primary fluid mixing plenum (residence time of 1 sec)

Ws_phx1   =  466.19            ; % secondary fluid mass flow rate in PHX, table 4 ORNL-TM-3832 (kg/s)
Ws_phx2   =  466.19            ;
Ws_phx3   =  466.19            ;
Ws_phx4   =  466.19            ;
Ws_phx5   =  466.19            ;
Ws_phx6   =  466.19            ;

ms_phxm   = (Ws_phx1 + Ws_phx2)*1; % mass in the secondary fluid mixing plenum (residence time of 1 sec)

Cp_p_phx  =  Cp_f              ; % 1339.78e-6            ; % PHX primary fluid specific heat capacity, table 2 ORNL-TM-3832 (MJ/kg/�C) 
Cp_s_phx  =  depl_Cp_FLiBe_coef*2386.48e-6        ; % PHX secondary fluid specific heat capacity, table 2 ORNL-TM-3832(MJ/kg/�C)
Cp_t_phx  =  depl_Cp_hAlloy_coef*577.78e-6         ; % PHX Hastelloy tube specific heat capacity, ORNL-TM-0728 pp. 20(MJ/kg/�C)

% mass of PHX nodes (kg)
% All masses were calculated using the volume in ORNL-TM-3832 table 2 and the density calculated from ORNL-TM-3832 table 3
% The mass of the tube was found using the volume in ORNL-TM-3832 table 2 and a density of 8774.5 kg/m^3 from ORNL-TM-0728 pp. 20

mp_phx1   = depl_den_Fuel_coef*[494.7, 494.7, 494.7, 494.7]; % PHX1 primary nodes (kg)
mt_phx1   = depl_den_hAlloy_coef*[1323.6, 1323.6]; % PHX1 tube nodes (kg)
ms_phx1   = depl_den_FLiBe_coef*[1152.5, 1152.5, 1152.5, 1152.5]; % PHX1 secondary nodes (kg)

mp_phx2   = depl_den_Fuel_coef*[494.7, 494.7, 494.7, 494.7]; % PHX2 primary nodes (kg)
mt_phx2   = depl_den_hAlloy_coef*[1323.6, 1323.6]; % PHX2 tube nodes (kg)
ms_phx2   = depl_den_FLiBe_coef*[1152.5, 1152.5, 1152.5, 1152.5]; % PHX2 secondary nodes (kg)

mp_phx3   = depl_den_Fuel_coef*[494.7, 494.7, 494.7, 494.7]; % PHX3 primary nodes (kg)
mt_phx3   = depl_den_hAlloy_coef*[1323.6, 1323.6]; % PHX3 tube nodes (kg)
ms_phx3   = depl_den_FLiBe_coef*[1152.5, 1152.5, 1152.5, 1152.5]; % PHX3 secondary nodes (kg)

mp_phx4   = depl_den_Fuel_coef*[494.7, 494.7, 494.7, 494.7]; % PHX4 primary nodes (kg)
mt_phx4   = depl_den_hAlloy_coef*[1323.6, 1323.6]; % PHX4 tube nodes (kg)
ms_phx4   = depl_den_FLiBe_coef*[1152.5, 1152.5, 1152.5, 1152.5]; % PHX4 secondary nodes (kg)

mp_phx5   = depl_den_Fuel_coef*[494.7, 494.7, 494.7, 494.7]; % PHX5 primary nodes (kg)
mt_phx5   = depl_den_hAlloy_coef*[1323.6, 1323.6]; % PHX5 tube nodes (kg)
ms_phx5   = depl_den_FLiBe_coef*[1152.5, 1152.5, 1152.5, 1152.5]; % PHX5 secondary nodes (kg)

mp_phx6   = depl_den_Fuel_coef*[494.7, 494.7, 494.7, 494.7]; % PHX6 primary nodes (kg)
mt_phx6   = depl_den_hAlloy_coef*[1323.6, 1323.6]; % PHX6 tube nodes (kg)
ms_phx6   = depl_den_FLiBe_coef*[1152.5, 1152.5, 1152.5, 1152.5]; % PHX6 secondary nodes (kg)

% (mass)*(specific heat capacity)
mcp_p_phx1 = Cp_p_phx*mp_phx1; % PHX1 primary nodes
mcp_t_phx1 = Cp_t_phx*mt_phx1; % PHX1 tube nodes
mcp_s_phx1 = Cp_s_phx*ms_phx1; % PHX1 secondary nodes

mcp_p_phx2 = Cp_p_phx*mp_phx2; % PHX2 primary nodes
mcp_t_phx2 = Cp_t_phx*mt_phx2; % PHX2 tube nodes
mcp_s_phx2 = Cp_s_phx*ms_phx2; % PHX2 secondary nodes

mcp_p_phx3 = Cp_p_phx*mp_phx3; % PHX3 primary nodes
mcp_t_phx3 = Cp_t_phx*mt_phx3; % PHX3 tube nodes
mcp_s_phx3 = Cp_s_phx*ms_phx3; % PHX3 secondary nodes

mcp_p_phx4 = Cp_p_phx*mp_phx4; % PHX4 primary nodes
mcp_t_phx4 = Cp_t_phx*mt_phx4; % PHX4 tube nodes
mcp_s_phx4 = Cp_s_phx*ms_phx4; % PHX4 secondary nodes

mcp_p_phx5 = Cp_p_phx*mp_phx5; % PHX5 primary nodes
mcp_t_phx5 = Cp_t_phx*mt_phx5; % PHX5 tube nodes
mcp_s_phx5 = Cp_s_phx*ms_phx5; % PHX5 secondary nodes

mcp_p_phx6 = Cp_p_phx*mp_phx6; % PHX6 primary nodes
mcp_t_phx6 = Cp_t_phx*mt_phx6; % PHX6 tube nodes
mcp_s_phx6 = Cp_s_phx*ms_phx6; % PHX6 secondary nodes

% heat transfer coefficient in PHX
% overall heat transfer coefficient was given, for now assumed to be the same heat transfer coefficient
h_p_phx = depl_h_pPHX_coef*7944.26e-6; % heat transfer coefficient of the primary nodes ORNL-TM-3832 table 2 (MW/m^2/�C)
h_s_phx = depl_h_sPHX_coef*7944.26e-6; % heat transfer coefficient of the secondary nodes ORNL-TM-3832 table 2 (MW/m^2/�C)

% area of heat transfer in PHX
A_p_phx = [76.81, 76.81, 76.81, 76.81]; % area of heat transfer for primary nodes ORNL-TM-3832 table 2 (m^2)
A_s_phx = [93.57, 93.57, 93.57, 93.57]; % area of heat transfer for secondary nodes ORNL-TM-3832 table 2 (m^2)

% (heat transfer coefficient)*(area)
hA_p_phx1 = h_p_phx*A_p_phx; % for primary/tube interface
hA_p_phx2 = h_p_phx*A_p_phx;
hA_p_phx3 = h_p_phx*A_p_phx;
hA_p_phx4 = h_p_phx*A_p_phx;
hA_p_phx5 = h_p_phx*A_p_phx;
hA_p_phx6 = h_p_phx*A_p_phx;

hA_s_phx1 = h_s_phx*A_s_phx; % for tube/secondary interface
hA_s_phx2 = h_s_phx*A_s_phx;
hA_s_phx3 = h_s_phx*A_s_phx;
hA_s_phx4 = h_s_phx*A_s_phx;
hA_s_phx5 = h_s_phx*A_s_phx;
hA_s_phx6 = h_s_phx*A_s_phx;

% initial temperatures (�C)
% calculated from temperatures in table 2 in ORNL-TM-3832

T0_p_phx1 = [648.89, 621.12, 593.34, 565.56]; % PHX1 primary nodes
T0_t_phx1 = [603.12, 547.57]; % PHX1 tube nodes
T0_s_phx1 = [510, 537.78, 565.55, 593.33]; % PHX1 secondary nodes

T0_p_phx2 = [648.89, 621.12, 593.34, 565.56]; % PHX2 primary nodes
T0_t_phx2 = [603.12, 547.57]; % PHX2 tube nodes
T0_s_phx2 = [510, 537.78, 565.55, 593.33]; % PHX2 secondary nodes

T0_p_phx3 = [648.89, 621.12, 593.34, 565.56]; % PHX3 primary nodes
T0_t_phx3 = [603.12, 547.57]; % PHX3 tube nodes
T0_s_phx3 = [510, 537.78, 565.55, 593.33]; % PHX3 secondary nodes

T0_p_phx4 = [648.89, 621.12, 593.34, 565.56]; % PHX4 primary nodes
T0_t_phx4 = [603.12, 547.57]; % PHX4 tube nodes
T0_s_phx4 = [510, 537.78, 565.55, 593.33]; % PHX4 secondary nodes

T0_p_phx5 = [648.89, 621.12, 593.34, 565.56]; % PHX5 primary nodes
T0_t_phx5 = [603.12, 547.57]; % PHX5 tube nodes
T0_s_phx5 = [510, 537.78, 565.55, 593.33]; % PHX5 secondary nodes

T0_p_phx6 = [648.89, 621.12, 593.34, 565.56]; % PHX6 primary nodes
T0_t_phx6 = [603.12, 547.57]; % PHX6 tube nodes
T0_s_phx6 = [510, 537.78, 565.55, 593.33]; % PHX6 secondary nodes

tau_c_hx = 1;
tau_hx_c = 1;
tau_phx_shx = 1;


%% Total Node Masses 
total_mp_phx = sum(mp_phx1) + sum(mp_phx2) + sum(mp_phx3) + sum(mp_phx4) + sum(mp_phx5) + sum(mp_phx6); %total mass of fuel in 6phxs

m_f_t= total_mp_phx + core_fm + mp_phxm*3 + m_fm;  %total fuel mass = loop mass + core mass (pipe mass here is loop mass from line 79)

%% SHX heat transfer parameters

Wp_shx1   = Ws_phx1           ; % primary fluid mass flow rate in SHX, same as PHX secondary flow rate
Wp_shx2   = Ws_phx2           ;
Wp_shx3   = Ws_phx3           ;
Wp_shx4   = Ws_phx4           ;
Wp_shx5   = Ws_phx5           ;
Wp_shx6   = Ws_phx6           ;

mp_shxm    = (Wp_shx1 + Wp_shx2)*1;  % mass in the primary fluid mixing plenum (residence time of 1 sec)

Ws_shx1   = 7.181839439165465e+02            ; % secondary fluid mass flow rate in SHX, ORNL-TM-3832 table 4 (kg/s)
Ws_shx2   = 7.181839439165465e+02            ;
Ws_shx3   = 7.181839439165465e+02            ;
Ws_shx4   = 7.181839439165465e+02            ;
Ws_shx5   = 7.181839439165465e+02            ;
Ws_shx6   = 7.181839439165465e+02            ;

W_3       = Ws_shx1 + Ws_shx2 + Ws_shx3 + Ws_shx4 + Ws_shx5 + Ws_shx6; % Hitec salt total flow rate

% Hitec salt flow rate from each loop
W_31      = W_3/3; 
W_32      = W_3/3;
W_33      = W_3/3;

m_3m      = W_3*2; % Hitec salt mixing plenum (residence time of 2 second) 

ms_shxm   = (Ws_shx1 + Ws_shx2)*1;  % mass in the secondary fluid mixing plenum (residence time of 1 sec)

Cp_p_shx = Cp_s_phx           ; % PHX primary fluid specific heat capacity (J/kg/�C) 
Cp_s_shx = depl_Cp_HITEC_coef*1549.12e-6            ; % PHX secondary fluid specific heat capacity ORNL-TM-3832 table 3(MJ/kg/�C)

% mass of THX nodes (kg)
% All masses were calculated using the volume in ORNL-TM-3832 table 4 and the density calculated from ORNL-TM-3832 table 3

mp_shx1   = depl_den_FLiBe_coef*[429.3, 429.3, 429.3, 429.3]; % SHX1 primary nodes
mt_shx1   = depl_den_hAlloy_coef*[1940, 1940]; % SHX1 tube nodes
ms_shx1   = depl_den_HITEC_coef*[1861.5, 1861.5, 1861.5, 1861.5]; % SHX1 secondary nodes

mp_shx2   = depl_den_FLiBe_coef*[429.3, 429.3, 429.3, 429.3]; % SHX2 primary nodes
mt_shx2   = depl_den_hAlloy_coef*[1940, 1940]; % SHX2 tube nodes
ms_shx2   = depl_den_HITEC_coef*[1861.5, 1861.5, 1861.5, 1861.5]; % SHX2 secondary nodes

mp_shx3   = depl_den_FLiBe_coef*[429.3, 429.3, 429.3, 429.3]; % SHX3 primary nodes
mt_shx3   = depl_den_hAlloy_coef*[1940, 1940]; % SHX3 tube nodes
ms_shx3   = depl_den_HITEC_coef*[1861.5, 1861.5, 1861.5, 1861.5]; % SHX3 secondary nodes

mp_shx4   = depl_den_FLiBe_coef*[429.3, 429.3, 429.3, 429.3]; % SHX4 primary nodes
mt_shx4   = depl_den_hAlloy_coef*[1940, 1940]; % SHX4 tube nodes
ms_shx4   = depl_den_HITEC_coef*[1861.5, 1861.5, 1861.5, 1861.5]; % SHX4 secondary nodes

mp_shx5   = depl_den_FLiBe_coef*[429.3, 429.3, 429.3, 429.3]; % SHX5 primary nodes
mt_shx5   = depl_den_hAlloy_coef*[1940, 1940]; % SHX5 tube nodes
ms_shx5   = depl_den_HITEC_coef*[1861.5, 1861.5, 1861.5, 1861.5]; % SHX5 secondary nodes

mp_shx6   = depl_den_FLiBe_coef*[429.3, 429.3, 429.3, 429.3]; % SHX6 primary nodes
mt_shx6   = depl_den_hAlloy_coef*[1940, 1940]; % SHX6 tube nodes
ms_shx6   = depl_den_HITEC_coef*[1861.5, 1861.5, 1861.5, 1861.5]; % SHX6 secondary nodes

% (mass)*(specific heat capacity)
mcp_p_shx1 = Cp_p_shx*mp_shx1; % SHX1 primary nodes
mcp_t_shx1 = Cp_t_phx*mt_shx1; % SHX1 tube nodes
mcp_s_shx1 = Cp_s_shx*ms_shx1; % SHX1 secondary nodes

mcp_p_shx2 = Cp_p_shx*mp_shx2; % SHX2 primary nodes
mcp_t_shx2 = Cp_t_phx*mt_shx2; % SHX2 tube nodes
mcp_s_shx2 = Cp_s_shx*ms_shx1; % SHX2 secondary nodes

mcp_p_shx3 = Cp_p_shx*mp_shx3; % SHX3 primary nodes
mcp_t_shx3 = Cp_t_phx*mt_shx3; % SHX3 tube nodes
mcp_s_shx3 = Cp_s_shx*ms_shx1; % SHX3 secondary nodes

mcp_p_shx4 = Cp_p_shx*mp_shx4; % SHX4 primary nodes
mcp_t_shx4 = Cp_t_phx*mt_shx4; % SHX4 tube nodes
mcp_s_shx4 = Cp_s_shx*ms_shx1; % SHX4 secondary nodes

mcp_p_shx5 = Cp_p_shx*mp_shx5; % SHX5 primary nodes
mcp_t_shx5 = Cp_t_phx*mt_shx5; % SHX5 tube nodes
mcp_s_shx5 = Cp_s_shx*ms_shx1; % SHX5 secondary nodes

mcp_p_shx6 = Cp_p_shx*mp_shx6; % SHX6 primary nodes
mcp_t_shx6 = Cp_t_phx*mt_shx6; % SHX6 tube nodes
mcp_s_shx6 = Cp_s_shx*ms_shx1; % SHX6 secondary nodes

% heat transfer coefficient in PHX
% overall heat transfer coefficient was given, for now assumed to be the same heat transfer coefficient
h_p_shx = depl_h_pSHX_coef*5674.46e-6; % heat transfer coefficient of the primary nodes ORNL-TM-3832 table 4 (MW/m^2/�C)
h_s_shx = depl_h_sSHX_coef*5674.46e-6; % heat transfer coefficient of the secondary nodes ORNL-TM-3832 table 4 (MW/m^2/�C)

% area of heat transfer in PHX
A_p_shx = [112.28, 112.28, 112.28, 112.28]; % area of heat transfer for primary nodes ORNL-TM-3832 table 4 (m^2)
A_s_shx = [137.142, 137.142, 137.142, 137.142]; % area of heat transfer for secondary nodes ORNL-TM-3832 table 4 (m^2)

% (heat transfer coefficient)*(area)
hA_p_shx1 = h_p_shx*A_p_shx; % for primary/tube interface
hA_p_shx2 = h_p_shx*A_p_shx;
hA_p_shx3 = h_p_shx*A_p_shx;
hA_p_shx4 = h_p_shx*A_p_shx;
hA_p_shx5 = h_p_shx*A_p_shx;
hA_p_shx6 = h_p_shx*A_p_shx;

hA_s_shx1 = h_s_shx*A_s_shx; % for tube/secondary interface
hA_s_shx2 = h_s_shx*A_s_shx;
hA_s_shx3 = h_s_shx*A_s_shx;
hA_s_shx4 = h_s_shx*A_s_shx;
hA_s_shx5 = h_s_shx*A_s_shx;
hA_s_shx6 = h_s_shx*A_s_shx;

% initial temperatures (�C)
T0_p_shx1 = [565.55, 537.78, 510, 482.22]; % SHX1 primary nodes
T0_t_shx1 = [538, 519.7]; % SHX1 tube nodes
T0_s_shx1 = [454.45, 482.23, 510, 537.78]; % SHX1 secondary nodes

T0_p_shx2 = [565.55, 537.78, 510, 482.22]; % SHX2 primary nodes
T0_t_shx2 = [538, 519.7]; % SHX2 tube nodes
T0_s_shx2 = [454.45, 482.23, 510, 537.78]; % SHX2 secondary nodes

T0_p_shx3 = [565.55, 537.78, 510, 482.22]; % SHX3 primary nodes
T0_t_shx3 = [538, 519.7]; % SHX3 tube nodes
T0_s_shx3 = [454.45, 482.23, 510, 537.78]; % SHX3 secondary nodes

T0_p_shx4 = [565.55, 537.78, 510, 482.22]; % SHX4 primary nodes
T0_t_shx4 = [538, 519.7]; % SHX4 tube nodes
T0_s_shx4 = [454.45, 482.23, 510, 537.78]; % SHX4 secondary nodes

T0_p_shx5 = [565.55, 537.78, 510, 482.22]; % SHX5 primary nodes
T0_t_shx5 = [538, 519.7]; % SHX5 tube nodes
T0_s_shx5 = [454.45, 482.23, 510, 537.78]; % SHX5 secondary nodes

T0_p_shx6 = [565.55, 537.78, 510, 482.22]; % SHX6 primary nodes
T0_t_shx6 = [538, 519.7]; % SHX6 tube nodes
T0_s_shx6 = [454.45, 482.23, 510, 537.78]; % SHX6 secondary nodes

tau_shx_phx = 1;
tau_shx_thx = 1;

T3_out       = 537.778;

%% Pump Parameters

therm_conv = 0.05; % Free convection flow fraction
K_pump = 1/5; %Pump flow rate decay constant


%% Xenon & Sm reactivity effects

gamma_I  = 5.1135e-2; % weighted yield for I-135
gamma_Xe = 1.1628e-2; % weighted yield for Xe-135

lam_I    = 2.875e-5;  % decay constant for I-135 (s^-1)
lam_Xe   = 2.0916e-5; % decay constant for Xe-135 (s^-1)

lam_bubl = 2.0e-2;    % effective bubbling out constant (s^-1)

sig_Xe   = 2.66449e-18; % (cm^2) microscopic cross-section for Xe (n,gamma) reaction 

%Atomic density calcultaion
molc_wt  = .715*(7.016+18.998)+.16*(9.012+2*18.998)+.12*(4*18.998+232.038)+.005*(4*18.998+235.044); % (g/mol)
molc_den = 0.001*den_f/molc_wt;          % (mol/cm^3)
U_den    = .005*molc_den*6.022E23;       % (#U/cm^3)
U_sig    = 5.851e-22;                    % (cm^2)

%Macro cross sections
Sig_f_msdr = U_den*U_sig;                % (cm^-1)
Sig_a = 1.02345; % (cm^-1) macroscopic absorption cross-section for core

phi_0 = P/(3.04414e-17*1e6*Sig_f_msdr);  % neutrons cm^-2 s^-1

I_0 = gamma_I*Sig_f_msdr*phi_0/lam_I; 
Xe_0 = (gamma_Xe*Sig_f_msdr*phi_0 + lam_I*I_0)/(lam_Xe + sig_Xe*phi_0 + lam_bubl);

Xe_og = lam_bubl*Xe_0/(lam_Xe); % initial Xe conc. in off-gas system

rhoXe_0 = (-sig_Xe/Sig_a)*(gamma_I+gamma_Xe)*Sig_f_msdr*phi_0/(lam_Xe + sig_Xe*phi_0 + lam_bubl);

gamma_Pm = 1.08E-2;  %Pm-149 yeild per fission
lam_Pm = log(2)/(2.21*24*3600);%decay constant of Pm-149 (s^-1)

sig_Sm = 42000*1e-24;%(n,abs) microscopic cross section of Sm-149 (cm^2)
% lam_Sm = (Stable) %decay constant of Sm-149 (s^-1) 

%Initial Pm & Sm atomic density
Pm_0 = (gamma_Pm*Sig_f_msdr*phi_0)/lam_Pm;
Sm_0 = (gamma_Pm*Sig_f_msdr)/sig_Sm;

Sm_0_core = Sm_0*(tau_c/(tau_c+tau_l));

rhoSm_0 = (sig_Sm*Sm_0_core)/(Sig_f_msdr + Sig_a);

%% Decay heat data
% this splits the fission products into 
Fiss_factor = 2.464783802008740e-03; % (rel to power) heat per fission relative to power rating [calculated]

% fission yeilds for each of the three groups lumped with heating factor
gamma0  = 9.635981959409105e-01;
gamma1  = 3.560674858154914e-02;
gamma2  = 7.950554775404400e-04;

% decay constants for each of the gorups
lambda0 = 0.0945298;
lambda1 = 0.00441957;
lambda2 = 8.60979e-05;

%% DRACS Parameters

%Normal DHRS
Power_Bleed= P*(0.00); %Some power will removed from DRACS even when its not used 
Epsilon=1E-3;
DHRS_TIME_K=10;

%Broken DHRS
rm_power = W_f*Cp_f*SlugDeltaTemp;
slug_end = DHRS_time+Slug_duration;

slug_heat_rm = [0 rm_power 0 0 ];
slugtime = [0 DHRS_time slug_end simtime];
slugger = timeseries(slug_heat_rm,slugtime);

%% Once Through Steam Generator

%%% Heat capacities and densities
Cp_p        = Cp_s_shx; % 5763.597e-6; % Water Cp_s_shx;    % [[MJ/(kg/�C)]        1.376611513    ; [BTU/F-lbm] % primary fluid                 
Cp_w        = 456.056e-6;  % [[MJ/(kg/�C)]        0.109          ; [BTU/F-lbm] % inconel                        
Cp_fw       = 3200.448e-6; % [[MJ/(kg/�C)]        1.122          ; [BTU/F-lbm] % feedwater                      
Cp_sc       = 4761.392e-6; % [[MJ/(kg/�C)]        1.138          ; [BTU/F-lbm] % subcooled fluid                
Cp_s        = 3588.208e-6; % [[MJ/(kg/�C)]        0.762          ; [BTU/F-lbm] % steam
rho_p       = 1685.142;    % 716.826;     % Water 1685.142;    % [kg/m^3] calculated using 130.6-(2.54e-2*T) (where T is in �F) Table3 ORNL-TM-3832  44.75          ; [lbm/ft^3] % primary fluid                  
rho_w       = 8425.712;    % [kg/m^3]       526            ; [lbm/ft^3] % inconel                        
rho_fw      = 828.507;     % [kg/m^3]       53.47          ; [lbm/ft^3] % feedwater                      
rho_f       = 751.042;     % [kg/m^3]       45.1380115     ; [lbm/ft^3] % boiling water density          
rho_sc      = (rho_fw + rho_f)/2;     % [kg/m^3]       50.76          ; [lbm/ft^3] % subcooled fluid density        
rho_b       = 186.32;     % [kg/m^3]       45.14          ; [lbm/ft^3] % boiling fluid density          
% rhodc     = 789.871;     % [kg/m^3]       49.31          ; [lbm/ft^3] % downcomer fluid density        
rho_s       = 26.5561;     % [kg/m^3]       1.5358         [lbm/ft^3] ; % steam density                  

P_s   = 12; % [MPa]
T_s   = (480 + 518)/2 + 273; 
[dum,dum,Cp_s,vss] = hsh(P_s, T_s); % vss == specific volume
Cp_s  = Cp_s*1e-6; % [MJ/kg-C]
rho_s = 1/vss; % [kg/m^3]

%%% Steam Generator Tube Side

N           = 6546;        % Number of Tubes                [-]
L_ft        = 28;          % [ft] need to use in a few places
L           = 8.5344;      % [m]            28             ; % Active Tube Length             [ft]          sg lengths
L_b         = 2.3645;     % [m]            19.6000        ; % Boiling Length                 [ft]          sg lengths
L_s         = 4.723;     % [m]             4.2000        ; % Steam Length                   [ft]                5.65boil       0.711779
L_sc        = 1.4469;     % [m]             4.2000        ; % Subcooled Length               [ft]                1.45film boil
D_ot        = 0.015875;    % [m]             0.052083333   ; % outer tube diameter            [ft]               2.875superheat  0.288220
T_th        = 0.0008636;   % [m]             0.002833333   ; % tube thickness                 [ft]
D_it        = 0.0141478;   % [m]             0.046416667   ; % internal tube diameter         [ft]               9.975total             1
R_it        = 0.0070739;   % [m]             0.023208333   ; % internal tube radius           [ft]                                 8.4000
R_ot        = 0.0079375;   % [m]             0.026041667   ; % outer tube radius              [ft]
A_sit       = 2483.0632;   % [m^2]       26727.470         ; % total surface area inner tube  [ft^2]
A_sot       = 2786.2020;   % [m^2]       29990.429         ; % total surface area outer tube  [ft^2]

%%% Initial State Calculations

M_stm       = 0.018;       % [kg/mol]        18.0000       ; % Molar weight of steam          [lbm/lb-mol]

P_table = 11.0:0.1:12.5; %Pressure;
Ts_avg = (459 + 411)/2 + 273;
T_table = [];
Hfg_table = [];
hs_table = [];

for PPP = 11.0:0.1:12.5
%     [T_sat] = hsat(PPP);
[T_sat,hf,hg,kf,kg] = hsat(PPP);
[dum, hss, dum, dum] = hsh(PPP, Ts_avg);
T_table = [T_table, T_sat];
hs_table = [hs_table, hss];
Hfg_table = [Hfg_table, hg-hf];
end
T_table = (T_table - 273); % Saturated temperature;
Hfg_table = Hfg_table*1e-6;
hs_table = hs_table*1e-6;
a = polyfit(P_table, T_table, 1);
X_5 = a(2); K_5 = a(1);
b = polyfit(P_table, Hfg_table, 1);
X_4 = b(2); K_4 = b(1);
c = polyfit(P_table, hs_table, 1);
dHs_dPs = c(1);

%%%%%%%%%% Temperature %%%%%%%%%%
T_p1        = 524.89;     % [�C]           609.28         ; % Primary Coolant Temperature nod[F]
T_p2        = 501.86;     % [�C]           608.86         ; % Primary Coolant Temperature nod[F]
T_p3        = 471.99;     % [�C]           591.86         ; % Primary Coolant Temperature nod[F]
T_p4        = 447.35;     % [�C]           581.37         ; % Primary Coolant Temperature nod[F]
T_p5        = 435.68;     % [�C]           577.92         ; % Primary Coolant Temperature nod[F]
T_p6        = 420.07;     % [�C]           567.51         ; % Primary Coolant Temperature nod[F]
T_w1        = 502.44;     % [�C]           608.62         ; % Temperature for wall node 1    [F]
T_w2        = 462.44;     % [�C]           607.63         ; % Temperature for wall node 2    [F]
T_w3        = 369.83;     % [�C]           574.36         ; % Temperature for wall node 3    [F]
T_w4        = 363.06;     % [�C]           570.57         ; % Temperature for wall node 4    [F]
T_w5        = 370.47;     % [�C]           569.32         ; % Temperature for wall node 5    [F]
T_w6        = 332.86;     % [�C]           541.60         ; % Temperature for wall node 6    [F]
T_s1        = 482.63;     % [�C]           596.69         ; % Temperature for superheated nod[F]
T_s2        = 427.66;     % [�C]           585.43         ; % Temperature for superheated nod[F]
T_sc2       = 280.26;     % [�C]           526.94         ; %                                [F]
T_fw        = 212.222;     % [�C]           414.00         ; % Feedwater temperature          [F]
T_sat       = T_sat - 273.15; % 295.812;     % [�C]           564.46         ; % Saturation temperature of the s[F]
T_pin       = 538;     % [�C]           609.50         ; % primary inlet temperature      [F]

%%%%%%%%%% Pressure %%%%%%%%%%
P_p1        = 0.0000;
P_p2        = 0.0000;
P_p3        = 0.0000;
P_p4        = 0.0000;
P_p5        = 0.0000;
P_p6        = 0.0000;
%P_sat       = 12.7; % [MPa]     170956.0125       ; % Saturation Pressure            [lbf/ft^2]
P_set       = 12.5; % [MPa]     118800.0000       ; % Steam Pressure Setpoint        [lbf/ft^2]
P_ss0       = 12.5; % [MPa]     118800.0000       ; % Pressure superheated steam lump[lbf/ft^2]
P_s         = 12.5; % [MPa]     118800.0000       ; % Pressure superheated steam lump[lbf/ft^2]
P_sc        = 12.5; % [MPa]     118800.0000       ; % Pressure subcooled initial     [lbf/ft^2]

deltaP = 0.5;
P_sat = (P_s + deltaP);
%X5=402.94; K5=0.14;  %Tsat~Psat
T_sat = X_5 + K_5*P_sat;
%Tsat=546.6;  %Exit temperature=317C and Degree of superheat is 43.4;
H_fg = X_4 + K_4*P_sat;

%%%%%%%%%% Mass Flow Rate %%%%%%%%%%
W_p0        = W_3; % 3779.937;    % [kg/s]        8333.3333       ; % Mass Flow Rate inlet           [lbm/s]
W_p1        = W_3; % 3779.937;    % [kg/s]        8333.3333       ; % Mass Flow Rate node 1          [lbm/s]
W_p2        = W_3; % 3779.937;    % [kg/s]        8333.3333       ; % Mass Flow Rate node 2          [lbm/s]
W_p3        = W_3; % 3779.937;    % [kg/s]        8333.3333       ; % Mass Flow Rate node 3          [lbm/s]
W_p4        = W_3; % 3779.937;    % [kg/s]        8333.3333       ; % Mass Flow Rate node 4          [lbm/s]
W_p5        = W_3; % 3779.937;    % [kg/s]        8333.3333       ; % Mass Flow Rate outlet          [lbm/s]
W_fw        = 321.5452;    % [kg/s]         500.0000       ; % Mass flow rate of feedwater    [lbm/s]

%%%%%%%%%% Area %%%%%%%%%%
A_pw1       = 186.2298;    % [m^2]         2004.5603       ; % heat transfer area of Node 1 pr[ft^2]
A_pw2       = 186.2298;    % [m^2]         2004.5603       ; % heat transfer area of Node 2 pr[ft^2]
A_pw3       = 869.0721;    % [m^2]         9354.6146       ; % heat transfer area of Node 3 pr[ft^2]
A_pw4       = 869.0721;    % [m^2]         9354.6146       ; % heat transfer area of Node 4 pr[ft^2]
A_pw5       = 186.2298;    % [m^2]         2004.5603       ; % heat transfer area of Node 5 pr[ft^2]
A_pw6       = 186.2298;    % [m^2]         2004.5603       ; % heat transfer area of Node 6 pr[ft^2]
A_ws1       = 208.9652;    % [m^2]         2249.2822       ; % Area of heat transfer node 1 tu[ft^2]
A_ws2       = 208.9652;    % [m^2]         2249.2822       ; % Area of heat transfer node 2 tu[ft^2]
A_ws3       = 975.1707;    % [m^2]        10496.6501       ; % Area of heat transfer node 3 tu[ft^2]
A_ws4       = 975.1707;    % [m^2]        10496.6501       ; % Area of heat transfer node 4 tu[ft^2]
A_ws5       = 208.9652;    % [m^2]         2249.2822       ; % Area of heat transfer node 5 tu[ft^2]
A_ws6       = 208.9652;    % [m^2]         2249.2822       ; % Area of heat transfer node 6 tu[ft^2]
A_s         = 1.2245;      % [m^2]           13.18         ; % Cross sectional secondary flow [ft^2]
A_p         = 1.0034;      % [m^2]           10.80         ; % Primary flow area              [ft^2]
A_w         = 0.2666;      % [m^2]            2.869655608  ; % Cross section for the tube;    [ft^2]

K_b         = 12.834854076292217;  % 
K_1         = 11.632248097704855;  %
K_sc        = -17.615718797133468; % 
dHs_dPs     = -0.042433622114357;  %

Z_ss        = 0.76634;      % Compressibility factor at 570 K, 60 atm
R           = 8.314462E-6; % [MJ/mol-�C] % Universal gas constant 

%%%%%%%%%% HEAT TRANSFER COEFFICIENTS %%%%%%%%%%
h_pw        = h_s_shx; %9101.343578935E-6; % [MW/m^2-�C]      1.8070       ; % Effective primary to wall heat [BTU/s-ft^2-F]
h_ws        = 5732.378387768E-6; % [MW/m^2-�C]      0.6672       ; % htc wall to steam node         [BTU/s-ft^2-F]
h_wb        = 13349.334646671E-6; % [MW/m^2-�C]      2.16647      ; % htc wall to boil node          [BTU/s-ft^2-F]
h_wsc       = 8385.005556375E-6; % [MW/m^2-�C]      1.18         ; %0.147 htc wall to subcooled node     [BTU/s-ft^2-F]

%% Alternative Ultimate Heat Sink
% UHX have three nodes that runs HITEC and remove demand power

total_tube_vol = pi*(R_it)^2*L*N; %[m^3]
n_UHX = 6;
UHX_node_vol = total_tube_vol/n_UHX;
mn_UHX = UHX_node_vol*rho_p;

tau_ostg_shx = total_tube_vol/W_3;

%% Variant Subsystems

OTSG=Simulink.Variant('UHX_MODE==1');

UHX=Simulink.Variant('UHX_MODE==2');