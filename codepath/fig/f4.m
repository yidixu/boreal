clear all
%% this is the demo for fig4
%% load the demo for f4
load('D:\OneDrive\Document\22-agbrecovery\4-figure\Boreal\SIFigure\datafolder\demo_f4.mat')
endyr=36;
addpath('codepath\function\m_map')
addpath('codepath\function\github_repo')
% World=shaperead('datafolder\gaul0_asap.shp');
World=shaperead('D:\OneDrive\Document\22-agbrecovery\1-data\worldmap\Global administrative boundaries\Joint Research Centre\ASAP national units-2\gaul0_asap.shp');
wx = [World(:).X];wy = [World(:).Y];
% lat lon of variables
lat_var=repmat((89.5:-1:-89.5)',[1 360]);
lon_var=repmat(-179.5:179.5,[180 1]);
%% below is the script to calculate the data in the demo_f4 (allready loaded), skip L14-140 to plot. 
% %% ratio_of
% econame='mypath\wwf_ecoregion.tif';
% [ecoregion_m,R]=geotiffread(econame);
% idx=logical(ecoregion_m>=1 & ecoregion_m<=4);
% % GABAM BA
% outpath='mypath\GABAM\8-BAarea\';
% outname=strcat(outpath,'BAareaann_f_1deg.mat');
% load(outname,'baann_f');
% outname=strcat(outpath,'BAareaann_nf_1deg.mat');
% load(outname,'baann_nf');
% ba_gabam=baann_f+baann_nf;  % 180 x 360 x 36 years 1985-2020
% % modified GABAM BA based on GFED and firecci
% outpath2 ='mypath\3-RF-ba-all\';
% outname=strcat(outpath2,'predictGFED_19852020.mat');
% ba_gfed=importdata(outname,'baall');  %36
% outname=strcat(outpath2,'predictfirecci_19852020.mat');
% ba_firecci=importdata(outname,'baall');  %36
% nansum(reshape(ba_gfed,[],1))./10000  %63.7397
% nansum(reshape(ba_firecci,[],1))./10000  %76.9062r
% ba_gfed(ba_gabam==0)=nan;
% ba_firecci(ba_gabam==0)=nan;
% nansum(reshape(ba_firecci,[],1))./10000  %75.4936
% nansum(reshape(ba_gfed,[],1))./10000    %59.7920
% % scale factor for the GABAM burned area -ratio_ff ratio_of 
% ba_m=ba_firecci;
% ba_m(ba_gabam==0)=nan;
% ba_ffm=baann_f./ba_gabam.*ba_firecci;
% ba_ofm=baann_nf./ba_gabam.*ba_firecci;
% ba_ffm(idx==1&isnan(ba_ffm))=0;
% ba_ofm(idx==1&isnan(ba_ofm))=0;
% a=unique(ba_ofm);%unique(ba_gfed./ba_gabam);
% a(isnan(a))=[];  
% nansum(reshape(ba_ffm+ba_ofm,[],1))./10000   %75.4936
% nansum(reshape(ba_ofm,[],1))./10000 
% nansum(reshape(ba_firecci,[],1))./10000
% ratio_of=ba_ofm./ba_gabam;
% ratio_ff=ba_ffm./ba_gabam;
% ratio_of(idx==1&isnan(ratio_of))=1;
% ratio_ff(idx==1&isnan(ratio_ff))=1;
% %% ghostsink
% test=10;
% outdir='mypath\GABAM\6-100m_c_firefreq-split2deg\ghostall\';
% outname=strcat(outdir,'t',num2str(test),'_ghostsink_ann_reg_source.mat');
% ghostann1=importdata(outname,'tempann');
% ghostann1_5084=sum(sum(ghostann1(:,:,86-35+1:86),3),2);
% ghostann1_all=sum(sum(ghostann1(:,:,:),3),2);
% test=12;
% outname=strcat(outdir,'t',num2str(test),'_ghostsink_ann_reg_source.mat');
% ghostann2=importdata(outname,'tempann');
% ghostann2_5084=sum(sum(ghostann2(:,:,86-35+1:86),3),2);
% ghostann2_all=sum(sum(ghostann2(:,:,:),3),2);
% test=11;
% outname=strcat(outdir,'t',num2str(test),'_ghostsink_ann_reg_source.mat');
% ghostann3=importdata(outname,'tempann');
% ghostann3_5084=sum(sum(ghostann3(:,:,86-35+1:86),3),2);
% ghostann3_all=sum(sum(ghostann3(:,:,:),3),2);
% %% ghostcwd
% test=12;
% outdir='mypath\GABAM\6-100m_cwd_firefreq\undistFright\obelix\';
% outname=strcat(outdir,'t',num2str(test),'_ghostcwd_ann_reg_source_ann4d.mat');
% ghostcwdann1=importdata(outname,'tempcwdann');
% ghostcwdann1_5084=sum(sum(ghostcwdann1(:,:,86-35+1:86),3),2);
% ghostcwdann1_all=sum(sum(ghostcwdann1(:,:,:),3),2);
% outdir='mypath\GABAM\6-100m_cwd_firefreq\undistFright_upper\obelix\';
% outname=strcat(outdir,'t',num2str(test),'_ghostcwd_ann_reg_source_ann4d.mat');
% ghostcwdann2=importdata(outname,'tempcwdann');
% ghostcwdann2_5084=sum(sum(ghostcwdann2(:,:,86-35+1:86),3),2);
% ghostcwdann2_all=sum(sum(ghostcwdann2(:,:,:),3),2);
% outdir='mypath\GABAM\6-100m_cwd_firefreq\undistFright_lower\obelix\';
% ghostcwd1=importdata(outname,'tempcwd');
% outname=strcat(outdir,'t',num2str(test),'_ghostcwd_ann_reg_source_ann4d.mat');
% ghostcwdann3=importdata(outname,'tempcwdann');
% ghostcwdann3_5084=sum(sum(ghostcwdann3(:,:,86-35+1:86),3),2);
% ghostcwdann3_all=sum(sum(ghostcwdann3(:,:,:),3),2);
% %% secsink 2021-2100
% %% sec sink
% out='mypath\GABAM\6-100m_c_firefreq-split2deg\sink20212100\';
% %
% test=12;
% outpath2=strcat(out,'bm2t',num2str(test),'\');
% outnamefull=strcat(outpath2,'4dSec20212100sinkannualfreq.mat');
% secsink4dff=importdata(outnamefull,'secsinkannglobalfreq4d');
% outnamefull=strcat(outpath2,'4dSec20212100sinkannualnofreq.mat');
% secsink4dof=importdata(outnamefull,'secsinkannglobalnofreq4d');
% % scaled by the scale factor 
% [seccountannsink1,secsink_reg1,secannofffsink1,seccall_ff,seccall_of] = f_sink_m(secsink4dff,secsink4dof,ratio_ff,ratio_of);
% sum(sum(secsink_reg1))*1000 
% sum(seccountannsink1)'       
% sum(seccountannsink1(1:36,:))'  
% %
% test=11;
% outpath2=strcat(out,'bm2t',num2str(test),'\');
% outnamefull=strcat(outpath2,'4dSec20212100sinkannualfreq.mat');
% secsink4dff=importdata(outnamefull,'secsinkannglobalfreq4d');
% outnamefull=strcat(outpath2,'4dSec20212100sinkannualnofreq.mat');
% secsink4dof=importdata(outnamefull,'secsinkannglobalnofreq4d');
% % scaled by the scale factor 
% [seccountannsink2,secsink_reg2,secannofffsink2,seccall_ff2,seccall_of2] = f_sink_m(secsink4dff,secsink4dof,ratio_ff,ratio_of);
% sum(sum(secsink_reg2))*1000  
% sum(seccountannsink2)'       
% sum(seccountannsink2(1:36,:))'  
% %
% test=10;
% outpath2=strcat(out,'bm2t',num2str(test),'\');
% outnamefull=strcat(outpath2,'4dSec20212100sinkannualfreq.mat');
% secsink4dff=importdata(outnamefull,'secsinkannglobalfreq4d');
% outnamefull=strcat(outpath2,'4dSec20212100sinkannualnofreq.mat');
% secsink4dof=importdata(outnamefull,'secsinkannglobalnofreq4d');
% % scaled by the scale factor 
% [seccountannsink3,secsink_reg3,secannofffsink3,seccall_ff3,seccall_of3] = f_sink_m(secsink4dff,secsink4dof,ratio_ff,ratio_of);
% sum(sum(secsink_reg3))*1000  
% sum(seccountannsink3)'       
% sum(seccountannsink3(1:36,:))'  
% %% 1985-2020 budget without legacy
% outname='D:\0-work\18-AGB\1-data\GABAM\6-100m_c_firefreq-split2deg\budget19852020.mat';
% load(outname)
% %% spatial data for Eagc and Ecwd
% endyr=36
% Eagcsp=Eagc_freq(:,:,1:36)+Eagc_nofreq(:,:,1:36);
% Ecwdsp=Esnagfiredecayall_freq(:,:,1:endyr)+Esnagfiredecayall_nofreq(:,:,1:endyr);
% csinkspall=csinksp+seccall_ff+seccall_of;
% seccsinksp=seccall_ff+seccall_of; % 
% sp_ghostcwd=importdata('mypath\GABAM\6-100m_cwd_firefreq\undistFright\ghostcwd19852100.mat','csnagann');
% sp_ghostsink=importdata('mypath\GABAM\6-100m_c_firefreq-split2deg\ghostall\ghostsink19852100.mat','csinkall_ann');
% spGcwd=sp_ghostcwd(:,:,1:endyr);
% spGsink=sp_ghostsink(:,:,1:endyr);




%% fig4a data
data1=(csinksp)*100/1000000000*0.5*1000;                            
data2=nansum(Eagcsp,3)*100/1000000000*0.5*1000;
data3=nansum(Ecwdsp,3)*100/1000000000*0.5*0.5*1000;
data4=nansum(spGsink,3)*100/1000000000*0.5*1000;
data5=nansum(spGcwd,3)*100/1000000000*0.5*0.5*1000;
data6=data4-data5;%net old
data7=data1-data2-data3;  % net young budget
data7(~idx)=nan;
data6(~idx)=nan;
cmap2rev=brewermap(256,'YlOrBr'); 
cmap2 = brewermap(256,'GnBu');
redblue=brewermap(256,'RdBu');
%% fig4b data
endyr=36;
countannsink19852100_1=[countannsink1;seccountannsink1];
countannsink19852100_2=[countannsink2;seccountannsink2];
countannsink19852100_3=[countannsink3;seccountannsink3];
[cumu_sink19852100mean,cumu_sink19852100std,sink19852100annmean,sink19852100annstd] = f_std2(countannsink19852100_1(1:endyr,:),countannsink19852100_2(1:endyr,:),countannsink19852100_3(1:endyr,:));
[cumu_gsinkmean,cumu_gsinkstd,gsinkannmean,gsinkannstd] = f_std2(ghostann1_all(1:endyr),ghostann2_all(1:endyr),ghostann3_all(1:endyr));
% [cumu_gsinkmax,cumu_gsinkmin,countanngsinkmin,countanngsinkmax,stdgsink] = f_cal_std3(ghostann1_all,ghostann2_all,ghostann3_all);
[cumu_gcwdmean,cumu_gcwdstd,gcwdannmean,gcwdannstd] = f_std2(ghostcwdann1_all(1:endyr),ghostcwdann2_all(1:endyr),ghostcwdann3_all(1:endyr));

endyr=36;
% endyr=116;
yearall=1985:2100;
X=yearall(1:endyr);
X2=yearall(1:36);
Y1=sink19852100annmean(:,4);
Y1std=sink19852100annstd(:,4);
X_plot  = [X, fliplr(X)];
X_plot2  = [X2, fliplr(X2)];
Y_plot  = [(Y1-Y1std)', fliplr((Y1+Y1std)')];

Y2=e1annmean(:,4);
Y2std=e1annstd(:,4);
Y_plot2 = [(Y2-Y2std)', fliplr((Y2+Y2std)')];
Y3=e2annmean(:,4)*0.5;
Y3std=e2annstd(:,4)*0.5;
Y_plot3 = [(Y3-Y3std)', fliplr((Y3+Y3std)')];

Y4=gsinkannmean;
Y4std=gsinkannstd;
Y_plot4 = [(Y4-Y4std)', fliplr((Y4+Y4std)')];
Y5=-gcwdannmean;
Y5std=gcwdannstd;
Y_plot5 = [(Y5-Y5std)', fliplr((Y5+Y5std)')];

a=zeros(116-36,1);
Y6=Y1+Y4+Y2+Y3+Y5;
Y6std=sqrt(Y1std.^2+Y2std.^2+Y3std.^2+Y4std.^2+Y5std.^2);
Y_plot6 = [(Y6-Y6std)', fliplr((Y6+Y6std)')];

%% plot
num=4;
cmap1=brewermap(11,'PiYg'); %RdBu
cmap=brewermap(10,'PiYg');
cmap(1:num+1,:)=cmap1(1:num+1,:);
cmap(num+1+1:10,:)=cmap1(7:11,:);
c4=[125 189 177]./255;
c1=[187 219 133]./255;
c5=[92 89 51]./255;
c3=[197 164 112]./255;
c2=[215,133,215]/255;

%% fig4 a
clf
ticnum=4;
region=1;
colorbarexist=0;
tiledlayout(2,2,'TileSpacing','compact');
titletext='a. ';
labeltext='Area (Mha)';
cmin=-1;
cmax=1;
ax7=nexttile;
[ax7] = map_ladder_value(cmax,cmin,redblue,data7,data7,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax7,region,colorbarexist);

ax7=nexttile;
titletext=' ';
labeltext='Area (Mha)';
cmin=-5;
cmax=5;
[ax7] = map_ladder_value(cmax,cmin,redblue,data6,data6,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax7,region,colorbarexist);

region=2;

ax8=nexttile;
ticnum=2;
titletext='';
labeltext='Young forest (Tg C)';
colorbarexist=1;
cmin=-1;
cmax=1;
[ax8] = map_ladder_value(cmax,cmin,redblue,data7,data7,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax8,region,colorbarexist);
hh = colorbar('southoutside');
hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
hh.TickLabels{1}=strcat('<',num2str(cmin));
hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));
hh.Label.FontSize = 11;

ax8=nexttile;
ticnum=2;
titletext='';
labeltext='Old forest (Tg C)';
colorbarexist=1;
cmin=-5;
cmax=5;
[ax8] = map_ladder_value(cmax,cmin,redblue,data6,data6,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax8,region,colorbarexist);
hh = colorbar('southoutside');
hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
hh.TickLabels{1}=strcat('<',num2str(cmin));
hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));
hh.Label.FontSize = 11;

%% fig4 b
clf
tiledlayout(1,3,'TileSpacing','compact');
nexttile(1,[1 2]);
Y0=repmat(0,[endyr 1]);
plot(X,Y0,'LineStyle','-','Marker','none',...
    'Color','k');
hold on

fill(X_plot, Y_plot , 1,....
    'facecolor',c1, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y1,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...  %'Marker','o'
    'LineStyle','-','LineWidth',1.5,...
    'Color',c1);
hold on

fill(X_plot2, Y_plot2 , 1,....
    'facecolor',c2, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X2,Y2,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c2);
hold on

fill(X_plot, Y_plot3 , 1,....
    'facecolor',c3, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y3,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c3);
hold on

fill(X_plot, Y_plot4 , 1,....
    'facecolor',c4, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y4,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c4);
hold on

fill(X_plot, Y_plot5 , 1,....
    'facecolor',c5, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y5,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c5);
hold on

fill(X_plot, Y_plot6 , 1,....
    'facecolor','k', ...
    'edgecolor','none', ...
    'facealpha', 0.1);
hold on
plot(X,Y6,'DisplayName','AGB', 'MarkerSize',2,'Marker','o',...
    'LineStyle','-','LineWidth',1.5,...
    'Color','k');
hold on
box off
% legend('','Sink (young forest)','','E_A_G_C (young forest)','','E_C_W_D (young forest)','','Legacy Sink (old forest)','', 'Legacy E_C_W_D (old forest)','', 'Net' , 'Location', 'bestoutside'); %, 'Location', 'NorthWest'
% legend('boxoff')
xlabel('Year')
ylabel('C change (Tg C yr^-^1)')
if endyr==36
    axis([1985 2020,-60,80])
else
axis([1985 2100,-60,80])
end
%% fig4c data
call=c1;
call(2,:)=c2;
call(3,:)=c3;
call(4,:)=c4;
call(5,:)=c5;
Ybar1=[cumu_sink19852100mean(:,4),sum(comb_agcfire(:,4)),sum(comb_newcwddecay(1:endyr,4))*0.5,cumu_gsinkmean,-cumu_gcwdmean];
net1=sum(Ybar1);
netstd1=sqrt(cumu_sink19852100std(:,4).^2+e1allstd(:,4).^2+e2allstd(:,4).^2+cumu_gsinkstd.^2+cumu_gcwdstd.^2);
%% fig4 c barplot
hold on
nexttile(3)
Ybar=[Ybar1];
Yscat=[net1];
Yscatstd=[netstd1];
Xbar = categorical({'1985-2020'});
Xbar = reordercats(Xbar,{'1985-2020'});
b=bar(Xbar,Ybar,0.5,'stacked','FaceColor','flat','EdgeColor','none');
for k = 1:size(Ybar,2)
    if k==2
        b(k).CData=[215,133,215]/255;
    else
    b(k).CData = call(k,:);
    end
end
hold on
e=errorbar(Xbar,Yscat,Yscatstd,'.');
e.Color = 'k';
e.CapSize = 15;
e.MarkerSize =18;
% legend('Sink(Young forest)','E_A_G_C(Young forest)','E_C_W_D(Young forest)','Legacy sink (old forest)','Legacy E_C_W_D (old forest)', 'Net' , 'Location', 'bestoutside'); %, 'Location', 'NorthWest'
% legend boxoff
box off
ylabel('Cumulative C change (TgC)')
xlabel('Period')
%%
outname=strcat('Figure4_cumu_19852020_right');
% set(gcf,'units','centimeters','position',[0 0 6 7])
set(gcf,'units','centimeters','position',[0 0 12 7])
saveas(gcf,[outpath,[outname,'.png']]);
%% function
function [cumu_mean,cumu_std,annmean,annstd] = f_std2(annofffsink1,annofffsink2,annofffsink3)
%F_CAL_STD 
temp=annofffsink1;
temp(:,:,2)=annofffsink2;
temp(:,:,3)=annofffsink3;
annstd=std(temp,0,3);
% annsinkmin=annofffsink1-stdsink;
% annsinkmax=annofffsink1+stdsink;
annmean=annofffsink1;
tempcumu=sum(temp,1);
cumu_std=std(tempcumu,0,3);
cumu_mean=sum(annofffsink1);
end

