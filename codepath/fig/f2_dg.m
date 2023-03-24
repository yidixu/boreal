clear all
%% for plot fig2d-g
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\codeshare\m_map')
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\codeshare\github_repo')
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\codeshare\function')
%% load demo data
load('D:\OneDrive\Document\22-agbrecovery\4-figure\Boreal\SIFigure\datafolder\demo_f2df_sp.mat');
%% plot
World=shaperead('D:\OneDrive\Document\22-agbrecovery\1-data\worldmap\Global administrative boundaries\Joint Research Centre\ASAP national units-2\gaul0_asap.shp');
wx = [World(:).X];wy = [World(:).Y];%
% lat lon of variables
lat_var=repmat((89.5:-1:-89.5)',[1 360]);
lon_var=repmat(-179.5:179.5,[180 1]);
%% plot AGBmax (med (q25-q75)) and recovery time to 90% AGBmax  
cmap2 = brewermap(256,'Spectral'); 
data1=agbeqf;
data2=agbeqnf;
data3=time90f;
data4=time90nf;
%% ladder
clf
tiledlayout(2,4,'TileSpacing','compact');
ticnum=3;
colorbarexist=0;
cmin=25;
cmax=100;
region=1;
titletext='';
labeltext='median=';
ax1=nexttile;
[ax1] = f_spmap(cmax,cmin,cmap2,data1,data1,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax1,region,colorbarexist,1,1);
ax2=nexttile;
cmin=50;
cmax=200;
[ax2] = f_spmap(cmax,cmin,cmap2,data2,data2,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax2,region,colorbarexist,1,1);
ax3=nexttile;
cmin=0;
cmax=50;
[ax3] = f_spmap(cmax,cmin,cmap2,data3,data3,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax3,region,colorbarexist,1,0);
ax4=nexttile;
cmin=25;
cmax=125;
[ax4] = f_spmap(cmax,cmin,cmap2,data4,data4,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax4,region,colorbarexist,1,1);
region=2;
labeltext='AGB_m_a_x (Mg ha^-^1)';

colorbarexist=1;
ax1=nexttile;
cmin=25;
cmax=100;
[ax1] = f_spmap(cmax,cmin,cmap2,data1,data1,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax1,region,colorbarexist,1,1);
ax2=nexttile;
cmin=50;
cmax=200;
[ax2] = f_spmap(cmax,cmin,cmap2,data2,data2,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax2,region,colorbarexist,1,1);
ax3=nexttile;
labeltext='\itt\rm _9_0 (yr)';
ticnum=2;
cmin=0;
cmax=50;
[ax3] = f_spmap(cmax,cmin,cmap2,data3,data3,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax3,region,colorbarexist,1,0);
ax4=nexttile;
cmin=25;
cmax=125;
[ax4] = f_spmap(cmax,cmin,cmap2,data4,data4,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax4,region,colorbarexist,1,1);
%% save figure
pixelsize=100;
outpath='yourpath\';
outname=strcat('fig2_dg.png');
set(gcf,'PaperOrientation','landscape','units','centimeters','position',[0 0 28 13])    % for figure
saveas(gcf,[outpath,[outname,'.pdf']]);