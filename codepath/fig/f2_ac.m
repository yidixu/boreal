clear all
%% plot the Figure 2 a-c
regionall={'North America' 'West Eurasia' 'East Eurasia'};
titleall={'a. ','b. ','c. '};
%  use region curve, Observ. vs. Estimate grouped by age for three regions
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\codeshare\')
age=[0:0.01:1 2:300];
inpath='D:\OneDrive\Code\27-Tropicaldist\5-bfrevision\codeshare\share_250731\datafolder\demo-f2ac\';
outpath='~yourpath\datafolder\demo-f2ac\';
if ~exist( outpath)
    mkdir( outpath)
end
%% load region curve
outname=strcat(inpath,'Regcurve_freqt12_interp.mat');  
load(outname,'fitcurve_freq')
outname=strcat(inpath,'Regcurve_nofreqt12_interp.mat');
load(outname,'fitcurve_nofreq')
%%
map = brewermap(5,'Set1'); 
map(1,:) = [0.9 0.9 0.9];
map(5,:) = [1 1 1];
test=12295;
for ri=1:3
    fitvalue_freq=[];
    fitvalue_nofreq=[];
    for ti=1:1
        
        outfile=strcat(inpath,'estimate_line_t',num2str(test),'.mat');
        load(outfile,'combine')
        comb=combine(combine(:,1)==ri,:);    
        fitvalue_freq_temp = f3_func(test,age,comb(:,11),comb(:,12),comb(:,13),comb(:,14),0,1);
        fitvalue_nofreq_temp = f3_func(test,age,comb(:,7),comb(:,8),comb(:,9),comb(:,10),0,1);
        fitvalue_freq=[fitvalue_freq;fitvalue_freq_temp];
        fitvalue_nofreq=[fitvalue_nofreq;fitvalue_nofreq_temp];
    end
    fitcurve_med_freq(ri,:)=nanmedian(fitvalue_freq);
    fitcurve_q25_freq(ri,:)=quantile(fitvalue_freq,0.25);
    fitcurve_q75_freq(ri,:)=quantile(fitvalue_freq,0.75);
    
    fitcurve_med_nofreq(ri,:)=nanmedian(fitvalue_nofreq);
    fitcurve_q25_nofreq(ri,:)=quantile(fitvalue_nofreq,0.25);
    fitcurve_q75_nofreq(ri,:)=quantile(fitvalue_nofreq,0.75);
end

%% different age bins
clf
tiledlayout(1,3)
ageint=20;
estima=[];
observ=[];
for ri=1:3
    outfile=strcat(inpath,'obs&est_age',num2str(ageint),'_reg',num2str(ri),'_rmrepeat.mat');
    load(outfile)
    outageint_val=outageint;
    num=130+ri;
    age2=[age];
    reg_fitcurve_med_f=[ fitcurve_freq(ri,:,1)];
    reg_fitcurve_q25_f=[ fitcurve_freq(ri,:,2)];
    reg_fitcurve_q75_f=[ fitcurve_freq(ri,:,3)];
    reg_fitcurve_med_nf=[ fitcurve_nofreq(ri,:,1)];
    reg_fitcurve_q25_nf=[ fitcurve_nofreq(ri,:,2)];
    reg_fitcurve_q75_nf=[ fitcurve_nofreq(ri,:,3)];
    fitcurve_med2=[ fitcurve_med_nofreq(ri,:)];
    ageff=[age2(1:150) 51:200 ];
    regcurve_ff=[reg_fitcurve_med_f(1:150) reg_fitcurve_med_f(101:150) reg_fitcurve_med_f(101:150) reg_fitcurve_med_f(101:150)];
    regcurve_q25ff=[reg_fitcurve_q25_f(1:150) reg_fitcurve_q25_f(101:150) reg_fitcurve_q25_f(101:150) reg_fitcurve_q25_f(101:150)];
    regcurve_q75ff=[reg_fitcurve_q75_f(1:150) reg_fitcurve_q75_f(101:150) reg_fitcurve_q75_f(101:150) reg_fitcurve_q75_f(101:150)];
    nexttile
    plot(age2,reg_fitcurve_med_nf,'color',[map(2,:)],'linewidth',1.5,'linestyle','--')
    hold on
    plot(ageff,regcurve_ff,'color',[map(3,:)],'linewidth',1.5,'linestyle','--')
    hold on
    fitcurve_q25_2=[ reg_fitcurve_q25_nf];
    fitcurve_q75_2=[ reg_fitcurve_q75_nf];
    p = fill([age2,fliplr(age2)],[fitcurve_q25_2,fliplr(fitcurve_q75_2)],'b','FaceColor',[map(2,:)],'facealpha',0.2,'EdgeColor','none');%FaceColorΪ�����ɫ��EdgeColorΪ�߿���ɫ
    hold on
    fitcurve_q25_2=[regcurve_q25ff];
    fitcurve_q75_2=[regcurve_q75ff];
    p = fill([ageff,fliplr(ageff)],[fitcurve_q25_2,fliplr(fitcurve_q75_2)],'b','FaceColor',[map(3,:)],'facealpha',0.2,'EdgeColor','none');%FaceColorΪ�����ɫ��EdgeColorΪ�߿���ɫ
    hold on
    e=errorbar(outageint_val(:,2)-3,outageint_val(:,5),outageint_val(:,5)-outageint_val(:,6),outageint_val(:,7)-outageint_val(:,5),'o');
    e.Marker = '.'; %o
    e.MarkerSize = 17;
    e.CapSize =0;
    e.Color = [237 131 132]./255;
    e.MarkerFaceColor=[237 131 132]./255;
    hold on
    eff=errorbar(outageint_val(:,2)+3,outageint_val(:,20),outageint_val(:,20)-outageint_val(:,21),outageint_val(:,22)-outageint_val(:,20),'o');
    eff.Marker = '.'; %o
    eff.MarkerSize = 17;
    eff.Color = 'black';
    eff.CapSize =0;
    eff.LineStyle = 'none';
    if ri==3
        legend( 'Regional curve (OF)','Regional curve (FF)','','','Observed AGB','Estimated AGB',...
            'Location', 'NorthWest' ,'fontsize',10);
        legend boxoff
    end
    hold on
    tit=cell2mat(titleall(ri));
    title(tit,'fontsize',12);
    ymax=300;
    text(80,ymax*0.9,sprintf(regionall{ri}),'FontSize',10);
    n=size(outageint_val(:,5),1);
    mse = sum((outageint_val(:,5) - outageint_val(:,20)).^2)./n;
    ax=get(gca);
    x=ax.XLim;
    y=ax.YLim;
    k=[0.8,0.3];
    x0=x(1)+k(1)*(x(2)-x(1));
    y0=y(1)+k(2)*(y(2)-y(1));
    set(gca,'Box','off')
    ylabel('AGB (Mg ha^-^1)');
    xlabel({'Age (yr)'});
    axis([0 200,0,300]) 
    set(gca,'xtick',[0:50:200]) 
    set(gca,'xticklabel',{'0','50','100','150','200'}) 
    set(gca,'ytick',[0:50:250]) 
    set(gca,'yticklabel',{'0','50','100','150','200','250'}) 
    ax = gca;
    ax.FontSize=12;
    ax.XAxis.TickDirection = 'out';
    ax.YAxis.TickDirection = 'out';
    ax.TitleHorizontalAlignment = 'left';
end
set(gcf,'PaperOrientation','landscape','units','centimeters','position',[0 0 28 8])    
%% save figure
outpath='yourpath\';
outname=strcat('fig2_abc');
saveas(gcf,[outpath,[outname,'.pdf']]);