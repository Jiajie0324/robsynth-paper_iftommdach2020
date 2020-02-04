clear
clc
repodir = fullfile(fileparts(which('structgeomsynth_path_init.m')), 'dimsynth', 'results');
optname = 'IFToMMDACH_Vgl_Winkel10_20200131_nachts_Wdh8';
robname = 'P6PRRRRR6V2G8P3A1';
robnr = 3;
resdir = fullfile(repodir, optname);

tmp = load(fullfile(resdir, sprintf('Rob%d_%s_Endergebnis.mat', robnr, robname)), ...
  'RobotOptRes', 'Set', 'Traj', 'PSO_Detail_Data');
% tmp.RobotOptRes.vartypes
parroblib_addtopath({tmp.RobotOptRes.Structure.Name});
tmp.RobotOptRes.fitnessfcn(tmp.RobotOptRes.p_val)
% disp(tmp.RobotOptRes.p_val)
% 
x_test = tmp.RobotOptRes.p_val(:);

tmp.PSO_Detail_Data.comptime
tmp.PSO_Detail_Data.fval
tmp.RobotOptRes.exitflag