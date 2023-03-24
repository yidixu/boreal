function [ax1] = map_ladder_value(cmax,cmin,cmap2,data,data2,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax1,region,colorbarexist)


if region==1
    ax1.FontSize=11;
    m_proj('lambert','long',[-180 -30],'lat',[45 75]);
    hold on
    m_coast('patch',[1 1 1],'edgecolor','k');
    m_pcolor(lon_var,lat_var,data);%绘制conbc_BCC_ESM1变量的填色图
    m_grid_Pole('ytick',[45 75],'yticklabels',[],'xticklabels',[],'fontsize',8,'backcolor',[0.9 0.9 0.9]);  %'yticklabels',[],
    %hold on;
    %m_plot(wx,wy,'k','linewidth',.3,'color',[0.8 0.8 0.8]);%绘制国界
    colormap(ax1,cmap2);
    caxis([cmin cmax]);
    %title(titletext,'fontsize',12);
    title(titletext,'fontsize',12);
    ax1.TitleHorizontalAlignment = 'left';
    if colorbarexist==1
        
        hh = colorbar('southoutside');
        hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
        hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));
        hh.Label.FontSize = 12;
        
        %ax = gca;
        

    end
    %ax = gca;
%    ax1.TitleHorizontalAlignment = 'left';
%     text(-.8,-0.3,sprintf('%3.2f Mha',nansum(reshape(data2,[],1))),'FontSize',10)
else
    ax1.FontSize=11;
    m_proj('lambert','long',[0 185],'lat',[45 75]);
    hold on
    m_coast('patch',[1 1 1],'edgecolor','k');
    m_pcolor(lon_var,lat_var,data);%绘制conbc_BCC_ESM1变量的填色图
    m_grid_Pole('ytick',[45 75],'yticklabels',[],'xticklabels',[],'fontsize',8,'backcolor',[0.9 0.9 0.9]);  %'yticklabels',[],

%     m_coast('patch',[.9 0.9 .9],'edgecolor','none');
%     m_pcolor(lon_var,lat_var,data);%绘制conbc_BCC_ESM1变量的填色图
%     %m_grid('linestyle','-','color','[0.5 0.5 0.5]','linewidth',.1,'ytick',[40 60 80]);
%     m_grid_Pole('ytick',[45 75],'fontsize',8);  %'yticklabels',[], 'xticklabels',[],
%     hold on;
%     m_plot(wx,wy,'k','linewidth',.3,'color',[0.8 0.8 0.8]);%绘制国界    
    colormap(ax1,cmap2);
    caxis([cmin cmax]);
    if colorbarexist==1
        hh = colorbar('southoutside');
        hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
        hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));
%         hh.TickLabels{1}=strcat('<',num2str(cmin));
        hh.Label.FontSize = 11;
    end
    title(titletext,'fontsize',12);
    %ax = gca;
    ax1.TitleHorizontalAlignment = 'left';
    %text(-1,-0.4,sprintf('%3.2f',data2),'FontSize',10)
    text(-.8,-0.4,sprintf('%3.0f TgC',nansum(reshape(data2,[],1))),'FontSize',10)
%     text(-.8,-0.4,sprintf('mean=%3.2f ',nanmean(reshape(data2,[],1))),'FontSize',10)
end

end

