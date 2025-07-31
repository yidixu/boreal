clear all
%% this is the demo for fig4
%% load the demo for f4
outname='D:\OneDrive\Code\27-Tropicaldist\5-bfrevision\codeshare\share_250731\datafolder\demo_f4.mat';
load(outname)
endyr=36;
addpath('codepath\function\m_map')
addpath('codepath\function\github_repo')
World=shaperead('D:\Seafile\1-arcgis\worldmap\Global administrative boundaries\Joint Research Centre\ASAP national units-2\gaul0_asap.shp');
wx = [World(:).X];wy = [World(:).Y];
reso=0.5;
lat_var=repmat((90-reso/2:-reso:-90+reso/2)',[1 360/reso]);
lon_var=repmat(-180+reso/2:reso:180-reso/2,[180/reso 1]);
%% below is the script to calculate the data in the demo_f4 (allready loaded), skip L14-140 to plot. 
econame='D:\Seafile\22-agb\wwf_ecoregion\wwf_econum_05deg_180360_modify_boreal_3sub.tif';
[subregion,R]=geotiffread(econame);
idx=logical(subregion>=1 & subregion<=4);
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
c2=[223 158 223]./255;
c55=[254 228 167]./255;
call=c1;
call(2,:)=c2;
call(3,:)=c3;
call(4,:)=c4;
call(5,:)=c5;
call(6,:)=c55;
%% e3 need to *0.5  CUE  e5 don't need to to that
clf
rid=4;
splitoldcwd=0; 
startyr=1;
endyr=36;
yearall=1985:2100;
X=yearall(startyr:endyr);
X2=yearall(startyr:endyr);
Y1=sink19852100annmean(startyr:endyr,rid);
Y1std=sink19852100annstd(startyr:endyr,rid);
X_plot  = [X, fliplr(X)];
X_plot2  = [X2, fliplr(X2)];
Y_plot  = [(Y1-Y1std)', fliplr((Y1+Y1std)')];
Y2=e1annmean(startyr:endyr,rid);
Y2std=e1annstd(startyr:endyr,rid);
Y_plot2 = [(Y2-Y2std)', fliplr((Y2+Y2std)')];
Y3=e2annmean(startyr:endyr,rid).*0.5; % CWD
Y3std=e2annstd(startyr:endyr,rid).*0.5;
Y_plot3 = [(Y3-Y3std)', fliplr((Y3+Y3std)')];
Y4=gsinkann_reg(:,rid);
Y4std=gsinkannstd_reg(:,rid);
Y_plot4 = [(Y4-Y4std)', fliplr((Y4+Y4std)')];
Y5=oldcwdannmeanreg(:,rid)+e3annmean(:,rid); %  oldcwdannmeanreg--OLD Ecwd+Ecwd remain
Y5std=oldcwdannstdreg(:,rid)+e3annstd(:,rid);
Y_plot5 = [(Y5-Y5std)', fliplr((Y5+Y5std)')];
a=zeros(116-36,1);
Y6=Y1+Y4+Y2+Y3+Y5;
Y6std=sqrt(Y1std.^2+Y2std.^2+Y3std.^2+Y4std.^2+Y5std.^2);
Y_plot6 = [(Y6-Y6std)', fliplr((Y6+Y6std)')];
Ybar1=[cumu_sink19852100mean(:,4),sum(cumu_e1meanff(1,4)+cumu_e1meanof(1,4)),sum(cumu_e2meanff(1,4)+cumu_e2meanof(1,4)),cumu_gsinkmean,cumu_oldcwdmean+cumu_oldcwdmean2];
net1=sum(Ybar1);
netstd1=sqrt(cumu_sink19852100std(:,4).^2+e1allstd(:,4).^2+(e2allstd(:,4).*0.5).^2+cumu_gsinkstd.^2+cumu_oldcwdstd.^2+cumu_oldcwdstd2.^2);
%% this fig4 a
reso=0.5;
data1=(csinksp)*100/1000000000*0.5*1000;                            % 0.4269 Pg C   Sink
data2=nansum(Eagcsp,3)*100/1000000000*0.5*1000;
data3=nansum(Ecwdsp,3)*100/1000000000*0.5*1000;
data4=nansum(spGsink,3)*100/1000000000*0.5*1000;
data5=nansum(spGcwd,3)*100/1000000000*0.5*1000;
data6=data4-data5;%net old
data7=data1-data2-data3;  % net young budget
data7(~idx)=nan;
data6(~idx)=nan;
cmap2rev=brewermap(256,'YlOrBr'); 
cmap2 = brewermap(256,'GnBu');
redblue=brewermap(256,'RdBu');
clf
tiledlayout(2,2,'TileSpacing','compact');
ticnum=4;
region=1;
colorbarexist=0;
tiledlayout(2,2,'TileSpacing','compact');
titletext='a. ';
labeltext='Area (Mha)';
cmin=-1*reso^2;
cmax=1*reso^2;
ax6=nexttile;
[ax6] = map_ladder_value(cmax,cmin,redblue,data7,data7,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax6,region,colorbarexist);
ax7=nexttile;
titletext=' ';
labeltext='Area (Mha)';
cmin=-1;
cmax=1;
[ax7] = map_ladder_value(cmax,cmin,redblue,data6,data6,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax7,region,colorbarexist);
region=2;
ax8=nexttile;
ticnum=2;
titletext='';
labeltext='Young forest (Tg C)';
colorbarexist=1;
cmin=-1*reso^2;
cmax=1*reso^2;
[ax8] = map_ladder_value(cmax,cmin,redblue,data7,data7,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax8,region,colorbarexist);
hh = colorbar('southoutside');
hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
hh.TickLabels{1}=strcat('<',num2str(cmin));
hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));
hh.Label.FontSize = 11;
ax9=nexttile;
ticnum=2;
titletext='';
labeltext='Ageing forest (Tg C)';
colorbarexist=1;
cmin=-1;
cmax=1;
[ax9] = map_ladder_value(cmax,cmin,redblue,data6,data6,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax9,region,colorbarexist);
hh = colorbar('southoutside');
hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
hh.TickLabels{1}=strcat('<',num2str(cmin));
hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));
hh.Label.FontSize = 11;

%% fig4 bc
figure
tiledlayout(1,3,'TileSpacing','compact');
nexttile(1,[1 2]);
Y0=repmat(0,[endyr 1]);
plot(X,Y0,'LineStyle','-','Marker','none',...
    'Color','k');
hold on
%young sink
fill(X_plot, Y_plot , 1,....
    'facecolor',c1, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y1,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...  %'Marker','o'
    'LineStyle','-','LineWidth',1.5,...
    'Color',c1);
hold on
% E AGC
fill(X_plot2, Y_plot2 , 1,....
    'facecolor',c2, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X2,Y2,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c2);
hold on
% young Ecwd 
fill(X_plot, Y_plot3 , 1,....
    'facecolor',c3, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y3,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c3);
hold on
% old sink
fill(X_plot, Y_plot4 , 1,....
    'facecolor',c4, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y4,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c4);
hold on
% old ECWD 
fill(X_plot, Y_plot5 , 1,....
    'facecolor',c5, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y5,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c5);
hold on
% old ECWD2
if splitoldcwd==1
    fill(X_plot, Y_plot55 , 1,....
        'facecolor',c55, ...
        'edgecolor','none', ...
        'facealpha', 0.3);
    hold on
    plot(X,Y55,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
        'LineStyle','-','LineWidth',1.5,...
        'Color',c55);
    hold on
end
% net
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
    axis([1985 2020,-120,120])
    % axis([1985 2020,-120,200])
else
axis([1985 2100,-60,80])
end

hold on
nexttile(3)
Ybar=[Ybar1];
Yscat=[net1];
Yscatstd=[netstd1];
Xbar = 1;  % use numeric index
b = bar(Xbar, Ybar, 1.5, 'stacked', 'FaceColor', 'flat', 'EdgeColor', 'none');
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
set(gca, 'XTick', 1, 'XTickLabel', {'1985-2020'})
% legend('Sink(Young forest)','E_A_G_C(Young forest)','E_C_W_D(Young forest)','Legacy sink (ageing forest)','Legacy E_C_W_D (ageing forest)', 'Net',' ' , 'Location', 'bestoutside'); %, 'Location', 'NorthWest'
box off
ylabel('Cumulative C change (TgC)')
xlabel('Period')


%% save the output
outpath='D:\OneDrive\Document\22-agbrecovery\4-figure\Boreal\SIbudget\bfrev\';
outname=strcat('Figure4_cumu');
saveas(gcf,strcat(outpath,outname,'.png'));