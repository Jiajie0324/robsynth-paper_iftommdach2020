clear
clc
repodir = fullfile(fileparts(which('structgeomsynth_path_init.m')), 'dimsynth', 'results');
outputdir = fullfile(repodir, 'IFToMMDACH_Vgl_20200203_nachts');
%% Untersuche alle Ergebnisse
% Gesamt-Tabelle wird durch anderes Matlab-Skript erzeugt
ResTableFile = fullfile(outputdir, 'all_results.csv');
ResTab_ges = readtable(ResTableFile);
% fval i.O. und gleichzeitig Grenzen verletzt?
I_fval_iO = ResTab_ges.Fval_Opt < 1e3;
I_condlimexc = ResTab_ges.Kondition_phys > 1e3;
I_matstressexc = ResTab_ges.Materialspannung > 1.0;

I_inplaus = I_fval_iO & I_condlimexc & I_matstressexc;
fprintf('%d Ergebnisse unplausibel\n', sum(I_inplaus));
%% Untersuche einzelnes Ergebnis

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