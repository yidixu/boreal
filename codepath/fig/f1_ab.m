%% demo_fig1_ab
clear all
addpath('D:\OneDrive\Code\General\m_map')
addpath('D:\OneDrive\Code\General\github_repo')
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\codeshare\share_1221\codepath\function\')
% read the required biomass/forest age/patcharea(pa)/fire frequency data (freqdata)
load('D:\OneDrive\Code\27-Tropicaldist\5-bfrevision\codeshare\share_250731\datafolder\demof1ab.mat')
reso_ori=data.reso_ori;
agedata=data.agedata;
freqdata=data.freqdata;
age1985=data.age1985;
tc2020=data.tc2020;
bm2020=data.bm2020;
pa=data.pa; % patcharea
Rori=data.Rori;
cmap2=data.cmap2;
cmap1=data.cmap1;
proj=data.proj;
%%
cmax1=100;
cmax2=150;
cmin1=0;
cmin2=0;
latlon='64_-113';
lat1=63.35;
lat2=63.25;
lon1=-112.8;
lon2=-112.7;
Lat_startth=proj.SpatialRef.LatitudeLimits(2);
Lat_endth=proj.SpatialRef.LatitudeLimits(1);
Long_startth=proj.SpatialRef.LongitudeLimits(1);
Long_endth=proj.SpatialRef.LongitudeLimits(2);
area_s=f1_gcsarea(reso_ori,Lat_startth,Lat_endth,Long_startth,Long_endth);
bigfire_th=40.47./(100.*area_s);
patchid=1;
if patchid==1
    agedata(pa<bigfire_th)=255;
end
agedata(agedata==100)=255;
agedata(tc2020<25)=255;
agedatacp=double(agedata);
agedatacp(freqdata==0|agedata==255)=nan;
agedatacp(age1985==10000 & isnan(agedatacp))=cmax1+1;
agedatacp(age1985<10000 & age1985>0 & isnan(agedatacp))=age1985(age1985<10000 & age1985>0 & isnan(agedatacp));
agedatacp(agedatacp>100&~isnan(agedatacp))=101;
agedatacp(isnan(agedatacp)&tc2020<25)=103;
agedata_f=double(agedata);
agedata_f(freqdata<=1&freqdata>0)=255;
agedata_nf=double(agedata);
agedata_nf(freqdata>10)=255; %scale by 10
agedata_f(agedata_f==255)=nan;
agedata_nf(agedata_nf==255)=nan;
bm2020_f=double(bm2020);
bm2020_nf=double(bm2020);
bm2020_cp=double(bm2020);
bm2020_nf(isnan(agedata_nf))=nan;
bm2020_f(isnan(agedata_f))=nan;
bm2020_cp(isnan(agedatacp))=nan;
length(find(~isnan(bm2020_nf)))
bm2020_cp(isnan(bm2020_cp))=bm2020_cp(isnan(bm2020_cp))+1;
bm2020_cp(agedatacp==103)=2;
%%
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\scriptall\function\')
lat_true=64;
lon_true =-113;
reso=0.5;
n=4000;
spliti=1:1/reso;
splitj=1:1/reso;
Long=[lon_true+reso/2:reso:(lon_true+1)-reso/2];
Lat=[lat_true-reso/2:-reso:(lat_true-1)+reso/2];
kk=(fi-1)*(1/reso).^2;
si=2
sj=1
rowslfit=n/(1/reso);
colslfit=n/(1/reso);
bm2020_cpt=FUNCSsubimg.subimg(bm2020_cp,1,reso,si,sj);
agedatacpt=FUNCSsubimg.subimg(agedatacp,1,reso,si,sj);
agedata_ft=FUNCSsubimg.subimg(agedata_f,1,reso,si,sj);
pathrow2=strcat(num2str(round(Lat(si)+reso/2,2)),'_',num2str(round(Long(sj)-reso/2,2)));
R_reso=f_createR_reso(reso_ori,Lat(si)+reso/2,Long(sj)-reso/2,size(agedata_ft,1),size(agedata_ft,2));
bm2020_cpt(isnan(bm2020_cpt))=bm2020_cpt(isnan(bm2020_cpt))+1;
bm2020_cpt(isnan(bm2020_cpt))=0;
bm2020_cpt(agedatacpt==103)=2;
%% plot
clf  
tiledlayout(1,3)
ax1 = nexttile;
outcount=bm2020_cpt;
outcount(agedatacpt==103)=1;
geoshow(outcount,R_reso,'DisplayType','Texturemap')
colorbar('southoutside'); %'Position',[0.1 0.2 0.3 0.05]
colormap(ax1,cmap2)
caxis([cmin2 cmax2+1]);
title('a. Biomass data','fontsize',13);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlim([Long(sj)-reso/2, Long(sj)+reso/2]);
ylim([Lat(si)-reso/2,Lat(si)+reso/2]);
xticks([Long(sj)]);
if Long(sj)+reso/2<0
    lonlabel='W';
else
    lonlabel='E';
end
xticklabels({strcat(num2str(abs(round(Long(sj),2))),'°',lonlabel) });
yticks([Lat(si)]);
yticklabels({strcat(num2str(abs(round(Lat(si),2))),'°N') });
ytickangle(90);
ax2 = nexttile;
cmap1(1,:)=[0.8 0.8 0.8];
cmap1(103,:)=[1 1 1];
outcount=agedatacpt;
geoshow(outcount,R_reso,'DisplayType','Texturemap')
caxis([cmin1 cmax1+3]);
colormap(ax2,cmap1)
title('b. Age','fontsize',13);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
contourff=agedata_ft;
contourff(isnan(contourff))=0;
contourff(contourff>0)=1;
contourm(contourff,R_reso, 'LineWidth',0.001,'LineStyle','--');%
colorbar('southoutside'); %
xlim([Long(sj)-reso/2, Long(sj)+reso/2]);
ylim([Lat(si)-reso/2,Lat(si)+reso/2]);
xticks([Long(sj)]);
if Long(sj)+reso/2<0
    lonlabel='W';
else
    lonlabel='E';
end
xticklabels({strcat(num2str(abs(round(Long(sj),2))),'°',lonlabel) });
yticks([Lat(si)]);
yticklabels({strcat(num2str(abs(round(Lat(si),2))),'°N') });
ytickangle(90);
% figure 3 enlarge
col_en=round((lon2-lon1).*4000);
row_en=round((lat1-lat2).*4000);
R1temp = georasterref();
R1temp.ColumnsStartFrom = 'north';
R1temp.RasterSize =[row_en col_en];
R1temp.LatitudeLimits =  [lat2 lat1];
R1temp.LongitudeLimits = [lon1 lon2];
[cols,rows ] = geographicToIntrinsic(R_reso,lat1,lon1);
rowe=round(rows)+(row_en-1);
cole=round(cols)+col_en-1;
enlargeimg=agedatacpt(round(rows):round(rowe),round(cols):round(cole));
ff_enlarge=agedata_ft(round(rows):round(rowe),round(cols):round(cole));
ax3 = nexttile;
geoshow(enlargeimg,R1temp,'DisplayType','Texturemap')
caxis([cmin1 cmax1+3]);
colormap(ax3,cmap1)
title('c. enlarge','fontsize',13);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
contourff_large=ff_enlarge;
contourff_large(isnan(contourff_large))=0;
contourff_large(contourff_large>0)=1;
contourm(contourff_large,R1temp, 'LineWidth',0.001,'LineStyle','--');%colorbar;  %'k',
hh = colorbar('southoutside'); %'Position',[0.1 0.2 0.3 0.05]
xticks(lon1+(lon2-lon1)/2);
if lon1+(lon2-lon1)/2<0
    lonlabel='W';
else
    lonlabel='E';
end
xticklabels({strcat(num2str(abs(round(lon1+(lon2-lon1)/2,2))),'°',lonlabel) });
yticks([lat2+(lat1-lat2)/2]);
yticklabels({strcat(num2str(abs(round([lat2+(lat1-lat2)/2],2))),'°N') });
ytickangle(90);
%%
Outfigure=strcat('../fig1_ab.png');
set(gcf,'units','centimeters','position',[0 0 15/2*3 12])
print(gcf,'-dpng','-r600',Outfigure)
