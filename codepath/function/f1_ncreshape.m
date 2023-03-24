function [out] = f1_ncreshape(filenamefull,varname,startLoc,count,ValueIdx)
    %from 67420 landpoint-to global latlon map at 0.5degx0.5deg
            value=ncread(filenamefull,varname,startLoc,count);   
           nday=size(value,2);
           data=zeros(720,360,nday);
           data(data==0)=nan;
           out=reshape(data,720*360,nday);
           out(ValueIdx,:)=value;
           out=reshape(out,720,360,nday);
           out=rot90(fliplr(out)); 
    end