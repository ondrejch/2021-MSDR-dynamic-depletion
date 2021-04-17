%%% MSDR with Decay Heat & Depletion
%%% Author: Visura Pathirana
%%% Building on work done by Vikram Sinha and Alex Wheeler
%%% Project advisor - Dr. Ondrej Chvala

%% Transient - 2
%%% Runs a simultanious OSTG trip and DHRS turn on
%%% Simulation done in two steps

%%% Step - 1; Simulation is run for 2000[s] at 750[Mw_t]
%%% Step - 2; Simultanious OSTG trip and DHRS turn on

%% User Inputs Start

%%% Basic Simulation Parameters
P = 750;                                                                   %Operational thermal power [MW]
simtime = 7000;                                                            %Simulation time [s]
ts_max = 1e-1;                                                             %Maximum timestep [s] 
rel_tolerance = 1e-5;                                                      %Relatve tolerance

%% Fuel Type
%%% fuel_type = 235; for FLibe with U235 (MSDR)
%%% fuel_type = 233; for FLiBe with U233 (MSRE)
%%% fuel_type = 123; for FLiBe with U235 with depletion accounting (MSDR)
fuel_type = 123;   

%%% Only for fuel_type = 123;
% depletion_time = 0;                                                        %Depletion point [days]

%% External Reactivity Insertions
reactdata = [0 0 0];                                                       %Reactivity insertions [abs]
reacttime = [0 2000 simtime];                                              %Reactivity insertion time [s]
react = timeseries(reactdata,reacttime);                                   %Defining source timeseries

%% Pump Trips

%%% Primary Pump Set
Trip_P1_pump = 2000000;                                                    %Time at which primary pump 1 is tripped [s]
Trip_P2_pump = 2000000;                                                    %Time at which primary pump 2 is tripped [s]
Trip_P3_pump = 2000000;                                                    %Time at which primary pump 3 is tripped [s]

%%% Secondary Pump Set
Trip_S1_pump = 2000000;                                                    %Time at which secondary pump 1 is tripped [s]
Trip_S2_pump = 2000000;                                                    %Time at which secondary pump 2 is tripped [s]
Trip_S3_pump = 2000000;                                                    %Time at which secondary pump 3 is tripped [s]

%%% Tertiary Pump Set
Trip_T1_pump = 2000000;                                                    %Time at which tertiary pump 1 is tripped [s]
Trip_T2_pump = 2000000;                                                    %Time at which tertiary pump 2 is tripped [s]
Trip_T3_pump = 2000000;                                                    %Time at which tertiary pump 3 is tripped [s]

%% UHX Parameters
%%% UHX_MODE = 1; uses an Once Through Steam Generator
%%% UHX_MODE = 2; uses a constant power removal block
%%% Both modes allow instant trip and demand follow
UHX_MODE = 1;
Trip_UHX = 2000;                                                           %Time at which ultimate heat exchanger is tripped [s]

demanddata = [1 1 1];                                                      %Reactivity insertions [abs]
demandtime = [0 2000 simtime];                                             %Reactivity insertion time [s]
demand = timeseries(demanddata,demandtime);                                %Defining source timeseries                              %Defining source timeseries

%% DHRS Parameters
%%% DHRS_MODE = 1; a sigmoid based DHRS (Normal DHRS)
%%% DHRS_MODE = 2; a square pulse based DHRS (Broken DHRS)
%%% DHRS_MODE = 1; allows modifications to sigmoid behavior using parameters with Normal DHRS in parameter file
%%% DHRS_MODE = 2; allows cold slug insertions
DHRS_MODE = 1; 
DHRS_time = 2000;                                                          %Time at which DRACS will be activated [s]

%%% Only for DHRS_MODE = 1
DHRS_Power = P*(0.03);                                                     %Maximum power that can be removed by DHRS
Power_Bleed = P*(0.00);                                                    %Some power can be removed from DRACS even when its not activated 

%%% Only for DHRS_MODE = 2
SlugDeltaTemp = 30;                                                        %Temperature drop by broken DHRS [deg. C]
Slug_duration = 10;                                                        %Duration of slug [s]

%% Run simulation

run('MSDR_DH_DeplV1para.m')
sim MSDR_DH_DeplV1sim.slx