function [area_s,area]=  f1_gcsarea(reso,Lat_start,Lat_end,Long_start,Long_end)

lat=180/reso;
lon=360/reso;
R = 6371.393;
for i=1:lat
    lat_area(i,1)=abs(2*pi*R^2*(cos(pi*i/lat)-cos(pi*(i-1)/lat)))/lon;
end
area=lat_area((90-Lat_start)/reso+1:(90-Lat_end)/reso);
clear lat_area;
area_s=repmat(area,[1 round((Long_end-Long_start)/reso)]);

end