%% demo_fig1_ab
addpath('D:\OneDrive\Code\General\m_map')
addpath('D:\OneDrive\Code\General\github_repo')
% read the required biomass/forest age/patcharea(pa)/fire frequency data (freqdata)
load('D:\OneDrive\Document\22-agbrecovery\4-figure\Boreal\SIFigure\datafolder\demof1ab.mat')
%
latlon='58_66';
% enlarge area
lat1=57.4;
lon1=66.3;
lat2=57.2;
lon2=66.5;
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
agedatacp(isnan(agedatacp)&tc2020<25)=103;
agedata_f=double(agedata);
%freqdata scale by 10, >10 --frequent fire pixel <10 occasional fire pixel
agedata_f(freqdata<=10&freqdata>0)=255; 
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
%% plot
clf 
tiledlayout(1,3)
ax1 = nexttile;
outcount=bm2020_cp;
geoshow(outcount,Rori,'DisplayType','Texturemap')
colormap(ax1,cmap2)
colorbar('southoutside');
caxis([cmin2 cmax2+1]);
title('a. Biomass','fontsize',13);
ax2 = nexttile;
outcount=agedatacp;
geoshow(outcount,Rori,'DisplayType','Texturemap')
caxis([cmin1 cmax1+3]);
colormap(ax2,cmap1)
title('b. Forest age','fontsize',13);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
% add contourff or not
contourff=agedata_f;
contourff(isnan(contourff))=0;
contourff(contourff>0)=1;
contourm(contourff,Rori, 'LineWidth',0.1,'LineStyle','--');%colorbar;  %'k',
colorbar('southoutside');
col_en=round((lon2-lon1).*1125);
row_en=round((lat1-lat2).*1125);
R1temp = georasterref();
R1temp.ColumnsStartFrom = 'north';
R1temp.RasterSize =[row_en col_en];
R1temp.LatitudeLimits =  [lat2 lat1];
R1temp.LongitudeLimits = [lon1 lon2];
[rows, cols ] = latlon2pix(Rori,lat1,lon1);
rowe=round(rows)+(row_en-1);
cole=round(cols)+col_en-1;
enlargeimg=agedatacp(round(rows):round(rowe),round(cols):round(cole));
ff_enlarge=agedata_f(round(rows):round(rowe),round(cols):round(cole));
ax3 = nexttile;
geoshow(enlargeimg,R1temp,'DisplayType','Texturemap')
caxis([cmin1 cmax1+3]);
colormap(ax3,cmap1)
title('c. enlarge','fontsize',13);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
% add contourff or not
contourff_large=ff_enlarge;
contourff_large(isnan(contourff_large))=0;
contourff_large(contourff_large>0)=1;
contourm(contourff_large,R1temp, 'LineWidth',0.2,'LineStyle','--');%colorbar;  %'k',
colorbar('southoutside');
Outfigure=strcat('../fig1_ab.png');
set(gcf,'units','centimeters','position',[0 0 15/2*3 12])
print(gcf,'-dpng','-r600',Outfigure)
