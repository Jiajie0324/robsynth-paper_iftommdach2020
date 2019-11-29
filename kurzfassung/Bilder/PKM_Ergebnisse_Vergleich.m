clc
clear
close all

cds_resdir = '/home/schappler/IMES/REPO/robotersynthese/structgeomsynth_schappler/dimsynth/results/3T3R_PKM_energy_20191128_nachts';
figure_dir = fileparts(which('PKM_Ergebnisse_Vergleich.m')); % Ordner dieser Datei
ErgDat = { ...
  'Rob7_P6PRRRRR6V2G4P3A1_Skizze_3D.fig', ...
  'Rob17_P6PRRRRR6G4P3A1_Skizze_3D.fig', ...
  'Rob3_P6RRRRRR10V3G1P1A1_Skizze_3D.fig', ...
  'Rob5_P6RRRRRR10G1P1A1_Skizze_3D.fig', ...
  };
for i = 3%1:length(ErgDat)
  close all
  figfile = fullfile(cds_resdir, ErgDat{i});
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
  [~,basename] = fileparts(ErgDat{i});
  name = sprintf('PaperRob%d_%s', i, basename);
  export_fig(fullfile(figure_dir, [name, '.pdf']));
  export_fig(fullfile(figure_dir, [name, '.png']));
  cd(figure_dir);
  export_fig([name, '_r864.png'], '-r864')
end