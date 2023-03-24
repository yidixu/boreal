function [output] = f_plotcurve(input)
%% fitcurve+plot
%% extract the parameter
xvalue=input{1};
yvalue=input{2};
xori=double(input{3});
yori=double(input{4});
pathrow=input{5};
num=input{6};
outpath=input{7};
type=input{8};
agenum=input{9};
agenum1=input{10};
agbeqpre=input{11};
agb_iflnear=input{12};
ymax=input{13};
iter=input{14};
xlim1=input{15};
testnum=input{16};
zeroidx=input{17};
logfile=input{18};
fii=input{19};
fid=fopen(logfile,'a');
%% Fit: 'prepare the data'.
[xData, yData] = prepareCurveData( xvalue, yvalue );
ifl=yData(xData==agenum);
rmidx=0;
if ~isnan(agbeqpre) && agbeqpre>0
    a=agbeqpre;
else
    a=agb_iflnear;
end
%% fitting the curve
para={type, testnum,zeroidx,xvalue,yvalue,xori,yori,agbeqpre,agb_iflnear,agenum};
[outcurve]=f_fitfunction(para);
fitresult=outcurve{1};
gof=outcurve{2};
curvepara=outcurve{3};
bestbeta=outcurve{6};
se=outcurve{7};
output={fitresult,gof,curvepara};
xmax=150;
xall=[0:1/30:1,1:xmax]';
[~,~,~,~,q25,q95] = f_montecarlo(bestbeta,se,a,type,xall,iter,zeroidx);

%% plot
% Plot fit with data.
for agei=0:agenum1
   if isempty(find(xori==agei, 1))
       addx=agei;
       addy=nan;
       xori=[xori;addx'];
       yori=[yori;addy'];
   end
end

fitvalue=fitresult(xall);%((0:150)');
p11(:,1)=q25;
p11(:,2)=q95;

clf
plot(xall,fitvalue)
hold on
X_plot  = [xall', fliplr((xall)')];
Y_plot  = [p11(:,1)', fliplr(p11(:,2)')];
fill(X_plot, Y_plot , 1,....
       'facecolor',[0	0.447058824	0.741176471], ...
       'edgecolor','none', ...
       'facealpha', 0.3);
hold on
plot([0;xvalue],[0;yvalue],'DisplayName','AGB', 'MarkerSize',5,'Marker','o',...
    'LineStyle','none',...
    'Color','k');
hold on
if ~isnan(agbeqpre)
   ageifl= agenum1-1+15;
   plot(ageifl,agbeqpre,'DisplayName','AGB', 'MarkerSize',20,'Marker','.',...
        'LineStyle','none',...
        'Color',[0,90/255,0]);
end
hold on
% if exist('agb_iflnear','var')
%    ageifl= agenum1-1;
%    agbifl_med=agb_iflnear;%nanmedian(ifl);
%    plot(ageifl,agbifl_med,'DisplayName','AGB', 'MarkerSize',20,'Marker','.',...
%         'LineStyle','none',...
%         'Color',[0,90/255,0]);
%     y23=agbifl_med;
% end
hold on
if type==12 || type==10 || type==11
    line([0, xlim1], [bestbeta(1), bestbeta(1)], 'Color', 'k');
    line([0, xlim1], [bestbeta(1)*0.9, bestbeta(1)*0.9], 'Color', [0 0 0], 'LineStyle','--');
end
if type==122 || type==102 || type==112
    line([0, xlim1], [agbeqpre, agbeqpre], 'Color', 'k');
    line([0, xlim1], [agbeqpre*0.9, agbeqpre*0.9], 'Color', [0 0 0], 'LineStyle','--');
end
figa=get(gca);
x=figa.XLim;
y=figa.YLim;
y(2)= max(max(p11));
y(1)= 0;
k=[0.75,0.35];
x0=x(1)+k(1)*(x(2)-x(1));
y0=0+k(2)*(y(2)-0);
legend( 'fitted curve','Uncertainty range','AGB points','95% AGB (region)','AGB_m_a_x', 'Location', 'NorthWest' ); % 'GlobBiomass2010',
%% calculate nrmse
% obs=yvalue;
% est=fitresult(xvalue);
% rmidx=logical(isnan(obs)|xvalue==0);
% obs(rmidx)=[];
% est(rmidx)=[];
% [~,~,nrmse,~,~,~,nrmser]=yd_sta(obs,est);
roundn(gof.rmse,-2);
text(30,ymax*0.15,sprintf('R^2 = %3.2g\nRMSE = %2.4g',gof.rsquare,gof.rmse),'FontSize',9)
% Label axes
ylabel('AGB (Mg ha^-^1)');
xlabel({'Forest age (yr)'});
axis([0 xlim1,0,ymax])
set(gca,'xtick',[0:xlim1/5:xlim1])
set(gca,'xticklabel',[0:xlim1/5:xlim1]) 
set(gca,'Box','off')
figa.XAxis.TickDirection = 'out';
figa.YAxis.TickDirection = 'out';
outname=strcat(outpath,pathrow,'_',num2str(num),'_',num2str(fii),'_plot.png');
set(gcf,'units','centimeters','position',[0 0 8 6])
print(outname,'-dpng')


