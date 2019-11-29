clc
clear
close all

cds_dir = '/home/schappler/IMES/REPO/robotersynthese/structgeomsynth_schappler/dimsynth/results';
figure_dir = fileparts(which('PKM_Ergebnisse_Vergleich.m')); % Ordner dieser Datei
ErgDat = { ...
  {'3T3R_PKM_energy_20191128_nachts', 'Rob7_P6PRRRRR6V2G4P3A1'}, ...
  {'3T3R_PKM_energy_20191128_nachts', 'Rob17_P6PRRRRR6G4P3A1'}, ...
  {'3T3R_PKM_energy_20191128_nachts', 'Rob3_P6RRRRRR10V3G1P1A1'}, ...
  {'3T3R_PKM_energy_20191128_nachts', 'Rob5_P6RRRRRR10G1P1A1'}, ...
  };
for i = 1:length(ErgDat)
  % Daten der Ergebnisse laden
  erg = load(fullfile(cds_dir, ErgDat{i}{1}, [ErgDat{i}{2},'_Endergebnis.mat']));
  fprintf('Ergebnis %d. %s:\n', i, ErgDat{i}{2});
  fprintf('Anzahl Variablen: %d\n', length(erg.RobotOptRes.Structure.vartypes));
  disp(strjoin(erg.RobotOptRes.Structure.varnames));
  fprintf('Parametertypen: [%s]\n', disp_array(erg.RobotOptRes.Structure.vartypes', '%1.0f'));
  continue
  close all
  figfile = fullfile(cds_dir, ErgDat{i}{1}, [ErgDat{i}{2},'_Skizze_3D.fig']);
  uiopen(figfile,1);
  f = gcf();
  set(f, 'windowstyle', 'normal');
  set_size_plot_subplot(f, ...
    8,8,gca,...
    0,0,0,0,0,0)
  drawnow();
  title('');xlabel('');ylabel('');zlabel('');
  % KS entfernen
  ch = get(gca, 'Children');
  for jj = 1:length(ch)
    if strcmp(ch(jj).Type, 'hgtransform')
      delete(ch(jj));
    end
  end
  set(gca,'XTICKLABEL',{});set(gca,'YTICKLABEL', {});set(gca,'ZTICKLABEL',{});
  [~,basename] = fileparts(ErgDat{i}{2});
  name = sprintf('PaperRob%d_%s', i, basename);
  export_fig(fullfile(figure_dir, [name, '.pdf']));
  export_fig(fullfile(figure_dir, [name, '.png']));
  cd(figure_dir);
  export_fig([name, '_r864.png'], '-r864')
end