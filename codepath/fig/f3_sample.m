clear all
% this is the demo for fig3
% load the demo for f3
addpath('codepath\function\m_map')
addpath('codepath\function\github_repo')
outname='D:\OneDrive\Document\22-agbrecovery\4-figure\Boreal\SIFigure\datafolder\demo_f3budget.mat';
load(outname)
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
%% CUE
regid=4; %% allregion  1-NA 2-WE 3-EE
clf
endyr=36;
yearall=1985:2100;
X=yearall(1:endyr);
X2=yearall(1:36);
Y1=countannsink1(:,regid);
Y1std=countannsinstd(:,regid);
X_plot  = [X, fliplr(X)];
X_plot2  = [X2, fliplr(X2)];
Y_plot  = [(Y1-Y1std)', fliplr((Y1+Y1std)')];

Y2=e1annmean(:,regid);
Y2std=e1annstd(:,regid);
Y_plot2 = [(Y2-Y2std)', fliplr((Y2+Y2std)')];
Y3=e2annmean(:,regid)*0.5;
Y3std=e2annstd(:,regid)*0.5;
Y_plot3 = [(Y3-Y3std)', fliplr((Y3+Y3std)')];
Y6=Y1+Y2+Y3;
Y6std=sqrt(Y1std.^2+Y2std.^2+Y3std.^2);
Y_plot6 = [(Y6-Y6std)', fliplr((Y6+Y6std)')];
%% fig4 bc
clf
tiledlayout(1,1,'TileSpacing','compact');
ax=nexttile(1,[1 1]);
Y0=repmat(0,[endyr 1]);
yyaxis left
plot(X,Y0,'LineStyle','-','Marker','none',...
    'Color','k');
hold on

fill(X_plot, Y_plot , 1,....
    'facecolor',c4, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y1,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...  %'Marker','o'
    'LineStyle','-','LineWidth',1.5,...
    'Color',c4);
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
    'facecolor',c5, ...
    'edgecolor','none', ...
    'facealpha', 0.3);
hold on
plot(X,Y3,'DisplayName','AGB', 'MarkerSize',5,'Marker','none',...
    'LineStyle','-','LineWidth',1.5,...
    'Color',c5);
hold on
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
%
yyaxis right
for yi=1:size(baall,3)
    baann(yi,1)=nansum(reshape(baall(:,:,yi),[],1))./10000;
end
Ybar=[baann]';
Xbar = X;
b=bar(Xbar,Ybar,0.5,'FaceColor','none','EdgeColor','k');
%%
yyaxis left
ax.YAxis(1).Color = 'k';
ylim([-25 45]);
ylabel('C change (Tg C yr^-^1)')
yyaxis right
ylabel('Burned area (Mha)')
xlabel('Year')
ax.YAxis(2).Color = 'k';
ylim([0 20]);
xlim([1985 2020])
%% output your location
outpath='yourpath\';
outname=strcat('fig3_sample.png');
set(gcf,'PaperOrientation','landscape','units','centimeters','position',[0 0 16 10])    % for figure
saveas(gcf,[outpath,[outname,'.png']]);