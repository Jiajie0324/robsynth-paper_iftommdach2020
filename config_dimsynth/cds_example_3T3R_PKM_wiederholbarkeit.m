% Einstellungen für komb. Struktur- und Maßsynthese für 3T3R PKM
% Auswertung Bezüglich Schwenkwinkeln und Konditionszahl

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-01
% (C) Institut für Mechatronische Systeme, Universität Hannover

clc
clear
% serroblib_create_template_functions({'S6PRRRRR6', 'S6PRRRRR6V2', 'S6RRRRRR10', 'S6RRRRRR10V3'}, false, true);
% mex_all_matlabfcn_in_dir('/home/schappler/IMES/REPO/robotersynthese/serrob_mdlbib/mdl_6dof/S6RRRRRR10/hd');
% mex_all_matlabfcn_in_dir('/home/schappler/IMES/REPO/robotersynthese/serrob_mdlbib/mdl_6dof/S6PRRRRR6/hd');
% Aufgaben-FG
DoF = [1 1 1 1 1 1];
Traj_no = 1;

Set = cds_settings_defaults(struct('DoF', DoF));
Set.task.Ts = 1e-2;
Set.task.Tv = 1e-1;
Set.task.profile = 1;

Set.optimization.objective = 'energy';
Set.optimization.NumIndividuals = 100;
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
Set.optimization.constraint_obj(4) = 1e3; % Konditionszahl darf nicht total schlecht sein
Set.optimization.constraint_link_yieldstrength = 1.0; % Beachte Materialbeanspruchung
Set.general.max_retry_bestfitness_reconstruction = 1;
Set.general.verbosity = 3;
Set.general.matfile_verbosity = 3;
Set.structures.use_serial = false;
Set.optimization.ee_rotation = false;
Set.general.parcomp_struct = true;
Set.general.nosummary = false;

% Auswahl für Paper
Set.structures.whitelist = { ...
  'P6PRRRRR6G8P3A1', 'P6PRRRRR6V2G8P3A1', ...
  'P6RRRRRR10G1P1A1', 'P6RRRRRR10V3G1P1A1'};
% Optimierung mehrfach wiederholen
for repno = 1:5
  % Verschiedene Schwenkwinkel durchgehen
  for maxangle = [60, 30, 45]
    % Einstellungen anpassen
    Set.optimization.optname = sprintf('IFToMMDACH_Vgl_Winkel%d_20200203_nachts_Wdh%d', ...
      maxangle, repno);
    Set.task.maxangle = maxangle*pi/180; 
    Traj = cds_gen_traj(DoF, Traj_no, Set.task);
    cds_start
  end
end