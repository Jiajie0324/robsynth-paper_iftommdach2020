% Einstellungen für komb. Struktur- und Maßsynthese für 3T3R PKM

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2019-09
% (C) Institut für Mechatronische Systeme, Universität Hannover

clc
clear

% Aufgaben-FG
DoF = [1 1 1 1 1 1];
Traj_no = 1;

Set = cds_settings_defaults(struct('DoF', DoF));
Set.task.Ts = 1e-2;
Set.task.Tv = 1e-1;
Set.task.profile = 1;
Set.task.maxangle = 10*pi/180; 
Traj = cds_gen_traj(DoF, Traj_no, Set.task);

Set.optimization.objective = 'energy';%'condition';
Set.optimization.optname = '3T3R_PKM_energy_20191129_v3_test';
Set.optimization.NumIndividuals = 70;
Set.optimization.MaxIter = 30;
Set.general.plot_details_in_fitness = 1e3*0;
Set.general.plot_robot_in_fitness = 1e3*0;
Set.optimization.base_size = true;
Set.optimization.base_size_limits = [1 2];
Set.optimization.platform_size = true;
Set.optimization.platform_size_limits = [0.3 1];
Set.optimization.base_morphology = true;
Set.optimization.platform_morphology = true;
Set.optimization.movebase = false;
Set.general.max_retry_bestfitness_reconstruction = 1;
Set.general.verbosity = 3;
Set.general.matfile_verbosity = 0;
Set.structures.use_serial = false;
Set.optimization.ee_rotation = false;
% Nur Auswahl Kugelgelenk-Ende-PKM
Set.structures.whitelist = {'P6RRRRRR10G1P1A1'};% ... % 'P6RRRRRR10V3G1P3A1', 'P6RRRRRR10V3G4P3A1',
% %   'P6PRRRRR6V2G4P3A1', 'P6RPRRRR12V2G4P1A1', ...
% %   'P6RRPRRR14V3G4P3A1'};
% Große Auswahl an Robotern:
% Set.structures.whitelist = { ...
% 'P6RRRRRR10G1P1A1', 'P6RRRRRR10V3G1P1A1', ... % IndRob G1P1
% 'P6RRRRRR10G1P1A2',  'P6RRRRRR10V3G1P1A2', ... % IndRob G1P1
% 'P6RRRRRR10G1P3A1', 'P6RRRRRR10V3G1P3A1', ... % IndRob G1P3
% 'P6RRRRRR10G4P3A1', 'P6RRRRRR10V3G4P3A1', ... % IndRob G4P3
% 'P6PRRRRR2G4P1A1', ... % P-5R (eine Variante)
% 'P6PRRRRR4G4P1A1', ... % P-5R (eine Variante)
% 'P6PRRRRR5G4P1A1', ... % P-5R (eine Variante)
% 'P6RPRRRR12V2G4P1A1', ...
% 'P6PRRRRR6G1P1A1', 'P6PRRRRR6V2G1P1A1', ... % 6PUS G1P1
% 'P6PRRRRR6G1P3A1', 'P6PRRRRR6V2G1P3A1', ... % 6PUS G1P3
% 'P6PRRRRR6G4P1A1', 'P6PRRRRR6V2G4P1A1', ... % 6PUS G4P1
% 'P6PRRRRR6G4P3A1', 'P6PRRRRR6V2G4P3A1', ... % 6PUS G4P3
% 'P6RRPRRR14G4P3A1', 'P6RRPRRR14V3G4P3A1'}; % 6UPS

% Auswahl für Paper

% Set.structures.whitelist = { ...
%   'P6PRRRRR6G4P1A1', 'P6PRRRRR6V2G4P1A1', ...
%   'P6PRRRRR6G4P3A1', 'P6PRRRRR6V2G4P3A1', ...
%   'P6RRRRRR10G1P1A1', 'P6RRRRRR10V3G1P1A1'};

cds_start
