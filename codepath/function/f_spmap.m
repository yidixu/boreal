function [ax1] = f_spmap(cmax,cmin,cmap2,data,data2,titletext,labeltext,ticnum,lat_var,lon_var,wx,wy,ax1,region,colorbarexist,hhmax,hhmin)
%% plot the spatial map
% read the world shapfile  World_Continents.shp
% World=shaperead('D:\OneDrive\Document\22-agbrecovery\1-data\worldmap\World_Continents\World_Continents.shp');
% wx = [World(:).X];wy = [World(:).Y];
% reso=1;
% lat_var=repmat((90-reso*0.5:-reso:-90+reso*0.5)',[1 360/reso]);
% lon_var=repmat(-180+.5*reso:reso:180-reso*0.5,[180/reso 1]);
if region==1
    ax1.FontSize=11;
    m_proj('lambert','long',[-180 -30],'lat',[45 75]);
    hold on
    m_coast('patch',[1 1 1],'edgecolor','k');
    m_pcolor(lon_var,lat_var,data);
    m_grid_Pole('ytick',[45 75],'fontsize',8,'backcolor',[0.9 0.9 0.9],'yticklabels',[],'xticklabels',[]);  %'yticklabels',[],
    colormap(ax1,cmap2);
    caxis([cmin cmax]);
    if colorbarexist==1
        hh = colorbar('southoutside');
        hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
        if hhmax==1
            hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));        
        end
        if hhmin==1
            hh.TickLabels{1}=strcat('<',num2str(cmin));        
        end
        hh.Label.FontSize = 12;
        ax1.TitleHorizontalAlignment = 'left';
        text(-1,-0.4,sprintf('median=%3.2f',nanmedian(reshape(data2,[],1))),'FontSize',10)
    end
elseif region==2
    ax1.FontSize=11;
    m_proj('lambert','long',[0 185],'lat',[45 75]);
    hold on
    m_coast('patch',[1 1 1],'edgecolor','k');
    m_pcolor(lon_var,lat_var,data);
    m_grid_Pole('ytick',[45 75],'fontsize',8,'backcolor',[0.9 0.9 0.9],'yticklabels',[],'xticklabels',[]);  %'yticklabels',[],
    colormap(ax1,cmap2);
    caxis([cmin cmax]);
    if colorbarexist==1
        hh = colorbar('southoutside');
        hh.Ticks = [cmin:(cmax-cmin)/ticnum:cmax]; hh.Label.String = labeltext;
        if hhmax==1
            hh.TickLabels{ticnum+1}=strcat('>',num2str(cmax));        
        end
        if hhmin==1
            hh.TickLabels{1}=strcat('<',num2str(cmin));        
        end
        hh.Label.FontSize = 11;
    end
    title(titletext,'fontsize',12);
    ax1.TitleHorizontalAlignment = 'left';
    text(-1,-0.4,sprintf('median=%3.2f',nanmedian(reshape(data2,[],1))),'FontSize',10)
end

end

