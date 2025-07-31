clear all
%% 1. extract agb value time since disturbance (forest age)
% time since last fire (forest age) + add the biomass from intact forest layer in the fitting at very old age
% select fire patch >100 arces and remove treeheight>0 after fire clearance
% identify frequent and occasional fire (FF fire>10 and OF fire <10)
%% 2. fit the Richard-Chapman function using the median of AGB for each age
%% 3. plot
%% add the required functions
addpath('D:\OneDrive\Code\000-obelix\AGBrecovery\codeshare\function\')
%% read the demo data; runtime:~5 min
load('D:\OneDrive\Code\27-Tropicaldist\5-bfrevision\codeshare\share_250731\datafolder\demo_f1cdfitcurve.mat')
%% curve selection
ffi=1 % frequent fire curve
ffi=2 % occasional fire curve
out1='/outpath/';
%% initialize
latinput=64;
loninput=-113;
ymax=60
iter=100000; % monte-carlo iteration time
%%
xlim1=50;
yearall=1985:2015;
ifl_age=80;
nodata=32767;
reso_ori=0.00025;
reso=0.5;
n=4000*reso;
targetPixelsize=0.5;
type=12;
bmdata=3;
freqtype=12;
occatype=122;
bmdata=2;
targetyear=2020;
latlonlength=10;
agenum1=targetyear-1985;
agenum=80;
testnum=3;
zeroidx=1;
k1=0;
k2=0;
ik=0;
%%
Lat_startth=proj.SpatialRef.LatitudeLimits(2);
Lat_endth=proj.SpatialRef.LatitudeLimits(1);
Long_startth=proj.SpatialRef.LongitudeLimits(1);
Long_endth=proj.SpatialRef.LongitudeLimits(2);
area_s=f1_gcsarea(reso_ori,Lat_startth,Lat_endth,Long_startth,Long_endth); %km^2
%% extract the value
n=round(1/reso_ori)/2;
new_size_ori=size(bm)./n;
new_size=ceil(new_size_ori);
ImgRow=new_size(1);
ImgCol=new_size(2);
Rn = georasterref();
Rn.ColumnsStartFrom = 'north';
Rn.RasterSize =new_size;
Bounding_Lat=round(Rori.LatitudeLimits);
Bounding_Long=round(Rori.LongitudeLimits);
Rn.LatitudeLimits=Bounding_Lat;
Rn.LongitudeLimits = Bounding_Long;
lon_start=Rn.LongitudeLimits(1)+0.5*Rn.CellExtentInLongitude;
lon_end=lon_start+Rn.CellExtentInLongitude*(Rn.RasterSize(2)-1);
lat_start=Rn.LatitudeLimits(2)-0.5*Rn.CellExtentInLatitude;
lat_end=lat_start-Rn.CellExtentInLatitude*(Rn.RasterSize(1)-1);
Long=[lon_start:Rn.CellExtentInLongitude:lon_end];
Lat=[lat_start:-Rn.CellExtentInLatitude:lat_end];
Longall=reshape(repmat(Long,ImgRow,1),[],1);
Latall=repmat(reshape(Lat,[],1),ImgCol,1);
row=uint8(repmat(reshape(1:ImgRow,[],1),ImgCol,1));
col=uint8(reshape(repmat(uint32(1:ImgCol),ImgRow,1),[],1));
id=(1:ImgRow*ImgCol)';
% columns={'Num','Lat','Long','Row','Col','ID'};
% dataout=table(id,Latall,Longall,row,col,id);

tiledlayout(1,1)
kk=1;
if ffi==1
    agedata_used=agedata_f;
    outpath2=outpath2_1;
    fitout=fitout_f;
    k=k1;
    typefreq=freqtype; % no pass AGB95%
    outpath=strcat(out1,'figureall\');
else
    agedata_used=agedata_nf;
    outpath2=outpath2_2;
    fitout=fitout_nf;
    typefreq=occatype; % pass AGB95%
    k=k2;
    outpath=strcat(out1,'figureall\');
end
if ~exist(outpath)
    mkdir(outpath)
end
%%
j=1;
i=2;
agb_iflnear = iflagb2deg(i,j);
k=k+1;
if i==new_size(1)
    if floor(new_size_ori(1))~=ceil(new_size_ori(1))
        x_start=(i-1)*n+1;
        x_end=size(bm,1);
    else
        x_start=(i-1)*n+1;
        x_end=i*n;
    end
else
    x_start=(i-1)*n+1;
    x_end=i*n;
end
if j==new_size(2)
    if floor(new_size_ori(1))~=ceil(new_size_ori(1))
        x_start=(i-1)*n+1;
        x_end=size(bm,1);
        y_start=(j-1)*n+1;
        y_end=size(bm,2);
    else
        y_start=(j-1)*n+1;
        y_end=j*n;
    end
else
    y_start=(j-1)*n+1;
    y_end=j*n;
end
x_start=round(x_start);
x_end=round(x_end);
if x_start>x_end
    x_start=x_end;
end
y_start=round(y_start);
y_end=round(y_end);
if y_start>y_end
    y_start=y_end;
end
bmtemp=bm(x_start:x_end,y_start:y_end);
freqtemp=freqdata(x_start:x_end,y_start:y_end);
bmfo=double(bmtemp);
bmfo(hansendata(x_start:x_end,y_start:y_end)<25)=nan;
bmfo(bmfo==nodata)=nan;
agb95=quantile(reshape(bmfo,[],1),0.95);
if isnan(agb95)
    agb95=-1;
end
[n1,n2]=size(bmtemp);
agetemp=agedata_used(x_start:x_end,y_start:y_end);
ifltemp=iflage(x_start:x_end,y_start:y_end);
ageall=unique(agetemp);
data=ones(n*n,agenum1,'uint16').*10000;
ageall(ageall==255|ageall==0)=[];
maxlength=1;
for ai=1:length(ageall)
    agei=ageall(ai);
    bmtt=reshape(bmtemp(agetemp==agei),1,[]);
    bmtt(bmtt==nodata)=[];
    if length(bmtt)>maxlength
        maxlength=length(bmtt);
    end
    data(1:length(bmtt),agei)=bmtt';
    OutData=bmtt';
end
ifl_s=(13+agenum*2-1)+1;
fitout(k,ifl_s+1:ifl_s+7)=0;
fitout(k,ifl_s)=0;
agei=ifl_age;
ifl=reshape(bmtemp(ifltemp==ifl_age),1,[]);
ifl(ifl==nodata)=[];
if ~isempty(ifl)
    fitout(k,ifl_s)=1;
    ifl_sta=[median(ifl) min(ifl) max(ifl) quantile(ifl,0.25) quantile(ifl,0.75)  mean(ifl) std(single(ifl))];
    fitout(k,ifl_s+1:ifl_s+7)=ifl_sta;
    iflmed=nanmedian(ifl);
end
fitout(k,ifl_s+8)=agb95;
clear ifl;
data(maxlength+1:n1*n2,:)=[];
[row,col]=size(data);
age=(1:col)';
Age=reshape(repmat(1:col,row,1),row*col,1);
GlobBiomass=double(reshape(data,[],1));
idx=logical(GlobBiomass==10000|Age>=80);
Age(idx)=[];
GlobBiomass(idx)=[];
data_rm=double(data);
data_rm(data_rm==10000)=nan;
agb_med=nanmedian(data_rm,1)';
try
    agb_med(agenum,1)=iflmed;
catch
    agb_med(agenum,1)=nan;
end
clear iflmed;
agb_med(agenum1+1:agenum-1,1)=nan;
clear data_rm;
age_med=(1:agenum)';
xvalue=age_med;
yvalue=agb_med;
xori=Age;
yori=GlobBiomass;
num=kk;
logfile='log.test';
input={xvalue, yvalue,xori, yori,pathrow,k,outpath,typefreq,agenum,agenum1,agb95,agb_iflnear,ymax,iter,xlim1,testnum,1,logfile,ffi};
[output] = f_plotcurve(input);

