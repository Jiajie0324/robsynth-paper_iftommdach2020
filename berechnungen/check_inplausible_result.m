clear
clc
repodir = fullfile(fileparts(which('structgeomsynth_path_init.m')), 'dimsynth', 'results');
optname = 'IFToMMDACH_Vgl_Winkel45_KondLim1_20200129_Wdh2';
robname = 'P6PRRRRR6G8P3A1';
robnr = 4;
resdir = fullfile(repodir, optname);

tmp = load(fullfile(resdir, sprintf('Rob%d_%s_Endergebnis.mat', robnr, robname)), ...
  'RobotOptRes', 'Set', 'Traj');
% tmp.RobotOptRes.vartypes
parroblib_addtopath({tmp.RobotOptRes.Structure.Name});
tmp.RobotOptRes.fitnessfcn(tmp.RobotOptRes.p_val)
% disp(tmp.RobotOptRes.p_val)
% 
x_test = tmp.RobotOptRes.p_val(:);

