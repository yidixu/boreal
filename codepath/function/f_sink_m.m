function [countannsink,sink_reg,annofffsink,call_ff,call_of] = f_sink_m(sink_ff4d,sink_of4d,ratio_ff,ratio_of)
%F_SINK scale the sink/emis using a scale factor ratio=predicted BA/GABAM BA 
%%
nsryear=size(sink_ff4d,4);
ntaryear=size(sink_ff4d,3);
sink_ff=zeros(180,360,ntaryear);
sink_of=zeros(180,360,ntaryear);
for yi=1:nsryear    
    rtemp1=ratio_ff(:,:,yi);
    rtemp1(isnan(rtemp1))=0;
    sinktemp=sink_ff4d(:,:,:,yi);
    sinktemp(isnan(sinktemp))=0;
    for yii=1:ntaryear
        sink_ff(:,:,yii)=sink_ff(:,:,yii)+sinktemp(:,:,yii).*rtemp1;
    end
    rtemp2=ratio_of(:,:,yi);
    rtemp2(isnan(rtemp2))=0;
    sinktemp=sink_of4d(:,:,:,yi);
    for yii=1:ntaryear
        sink_of(:,:,yii)=sink_of(:,:,yii)+sinktemp(:,:,yii).*rtemp2;
    end
end
%%
econame='D:/ownCloud/Seafile/22-agb/wwf_ecoregion/wwf_econum_1deg_180360_modify_boreal_3sub.tif';
[ecoregion_m]=geotiffread(econame);
idx=logical(ecoregion_m>=1&ecoregion_m<=3);
row=180;
col=360;
countann_ff=zeros(ntaryear,4);
countann_of=zeros(ntaryear,4);
call_ff=zeros(row,col);
call_of=zeros(row,col);
for yi=1:ntaryear
    yyi=yi;
    ctemp=sink_ff(:,:,yi);
    ctemp(~idx)=nan;
    countann_ff(yyi,4)=nansum(nansum(ctemp))*100/1000000000*0.5;   % PgC
    call_ff=call_ff+ctemp;
    for ri=1:3
        idxtemp=logical(ecoregion_m==ri);
        ctemp=sink_ff(:,:,yi);
        ctemp(~idxtemp)=nan;
        countann_ff(yyi,ri)=nansum(nansum(ctemp))*100/1000000000*0.5;   % PgC        
    end
end
for yi=1:ntaryear
    yyi=yi;
    ctemp=sink_of(:,:,yi);
    ctemp(~idx)=nan;
    countann_of(yyi,4)=nansum(nansum(ctemp))*100/1000000000*0.5;   % PgC
    call_of=call_of+ctemp;
    for ri=1:3
        idxtemp=logical(ecoregion_m==ri);
        ctemp=sink_of(:,:,yi);
        ctemp(~idxtemp)=nan;
        countann_of(yyi,ri)=nansum(nansum(ctemp))*100/1000000000*0.5;   % PgC        
    end
end
countannsink=[countann_ff(:,1)+countann_of(:,1) countann_ff(:,2)+countann_of(:,2) countann_ff(:,3)+countann_of(:,3) countann_ff(:,4)+countann_of(:,4)];
sink_reg=[sum(countann_ff(:,1:3))' sum(countann_of(:,1:3))'];
countannsink=countannsink.*1000;
cumu_sink=[sum(countann_ff(:,1:3))'  sum(countann_of(:,1:3))'];
annofffsink=[countann_ff countann_of].*1000; 
end

