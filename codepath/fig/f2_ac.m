

clear all
%% plot the Figure 2 a-c
regionall={'North America' 'West Eurasia' 'East Eurasia'};
titleall={'a. ','b. ','c. '};
%  use region curve, Observ. vs. Estimate grouped by age for three regions
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\codeshare\')
test=12295;
age=[0:0.01:1 2:300];
inpath='set your path';
outpath='set your output path';
outpath='~yourpath\datafolder\demo-f2ac\';
inpath='~yourpath\datafolder\demo-f2ac\';
% outpath='D:\OneDrive\Document\22-agbrecovery\4-figure\Boreal\SIFigure\datafolder\demo-f2ac\';
% inpath='D:\OneDrive\Document\22-agbrecovery\4-figure\Boreal\SIFigure\datafolder\demo-f2ac\';
if ~exist( outpath)
    mkdir( outpath)
end
%% load region curve
% outpath='D:\0-work\18-AGB\1-data\GABAM\6-100m_cwd_firefreq\';
outname=strcat(outpath,'Regcurve_freqt12.mat');   % fitcurve_freq(reg,age,
load(outname,'fitcurve_freq')
outname=strcat(outpath,'Regcurve_nofreqt12.mat');
load(outname,'fitcurve_nofreq')
%%
map = brewermap(5,'Set1'); 
map(1,:) = [0.9 0.9 0.9];
map(5,:) = [1 1 1];
testall=[12295,11295,10295];
for ri=1:3
    fitvalue_freq=[];
    fitvalue_nofreq=[];
    for ti=1:3
        test=testall(ti);
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
ageinterval=[5,10,15,20,25,30];
for aint=4:4
    ageint=ageinterval(aint);
    estima=[];
    observ=[];
    clf
    tiledlayout(1,3)
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
        %subplot(num)
        nexttile
        plot(age2,reg_fitcurve_med_nf,'color',[map(2,:)],'linewidth',1.5,'linestyle','--')
        hold on
        plot(age2,reg_fitcurve_med_f,'color',[map(3,:)],'linewidth',1.5,'linestyle','--')
        hold on
        fitcurve_q25_2=[ reg_fitcurve_q25_nf];
        fitcurve_q75_2=[ reg_fitcurve_q75_nf];
        p = fill([age2,fliplr(age2)],[fitcurve_q25_2,fliplr(fitcurve_q75_2)],'b','FaceColor',[map(2,:)],'facealpha',0.2,'EdgeColor','none');%FaceColorΪ�����ɫ��EdgeColorΪ�߿���ɫ
        hold on
        fitcurve_q25_2=[ reg_fitcurve_q25_f];
        fitcurve_q75_2=[ reg_fitcurve_q75_f];
        p = fill([age2,fliplr(age2)],[fitcurve_q25_2,fliplr(fitcurve_q75_2)],'b','FaceColor',[map(3,:)],'facealpha',0.2,'EdgeColor','none');%FaceColorΪ�����ɫ��EdgeColorΪ�߿���ɫ
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
        NRMSE=sqrt(immse(outageint_val(:,20),outageint_val(:,5)))/mean(outageint_val(:,5));
        observ=[observ; outageint_val(:,5)];
        estima=[estima; outageint_val(:,20)];     
        [r2,rmse]=yd_sta(outageint_val(:,5),outageint_val(:,20));
        tit=cell2mat(titleall(ri));
        title(tit,'fontsize',12);
        ymax=300;
        text(80,ymax*0.9,sprintf(regionall{ri}),'FontSize',10);
%         text(120,ymax*0.9,sprintf('R^2=%3.1f',r2),'FontSize',10);
%         text(120,ymax*0.8,sprintf('RMSE=%3.1f',rmse),'FontSize',10);
%         text(120,ymax*0.7,sprintf('NRMSE=%3.2f',NRMSE),'FontSize',10);
        n=size(outageint_val(:,5),1);
        mse = sum((outageint_val(:,5) - outageint_val(:,20)).^2)./n;
        ax=get(gca);
        x=ax.XLim;
        y=ax.YLim;
        k=[0.8,0.9];
        x0=x(1)+k(1)*(x(2)-x(1));
        y0=y(1)+k(2)*(y(2)-y(1));
        k=[0.8,0.3];
        x0=x(1)+k(1)*(x(2)-x(1));
        y0=y(1)+k(2)*(y(2)-y(1));
        set(gca,'Box','off')
        ylabel('AGB (Mg ha^-^1)');
        xlabel({'Age (yr)'});
        axis([0 200,0,300]) %500
        set(gca,'xtick',[0:50:200]) %[1,5,10,15,20,25]
        set(gca,'xticklabel',{'0','50','100','150','200'}) %[1,5,10,15,20,25]
        set(gca,'ytick',[0:50:250]) %[1,5,10,15,20,25]
        set(gca,'yticklabel',{'0','50','100','150','200','250'}) %[1,5,10,15,20,25]
        ax = gca;
        ax.FontSize=12;
        ax.XAxis.TickDirection = 'out';
        ax.YAxis.TickDirection = 'out';
        ax.TitleHorizontalAlignment = 'left';
    end    
    outname=strcat('errorbar_',num2str(ageint));
end
%% save figure
outpath='yourpath\';
outname=strcat('fig2_ac.png');
set(gcf,'PaperOrientation','landscape','units','centimeters','position',[0 0 28 13])    % for figure
saveas(gcf,[outpath,[outname,'.pdf']]);