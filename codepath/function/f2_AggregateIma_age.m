% date: Dec. 2020  modified by Yidi
function [ImaOUT,ImaOUT_count]=  f2_AggregateIma_age(ImaIN,n,Fct,area_s,datatype)

    % AggregateIma resize an image to a smaller one using 6 possible function
    % (Fct). --
    % in:
    % - ImaIN: image N dimension
    % - n: factor for aggregation. 
        % ex: if ImaIN is a 100 by 100 image and n=4, ImaOUT will be a 25*25 image
        % if ImaIN is a 101 by 103 image and n=4, ImaOUT will be a 26*26 image
    % 
    % - Fct: type of aggregation 
            % (Majority vote/mean/sum/weighted mean/wighted by specific area)
    % out = ImaOUT: aggregated image.

    % Notice that it works with N dimension image and an extra dimension is
    % temporally added to compute the aggregation. there is no pixel by pixel
    % (time consuming) computation.
    
    % Original Author: Martin Claverie, Univesity of Maryland
    % date: November 2012
    % modified by Yidi XU 

    new_size_ori=size(ImaIN)./n;
    new_size=ceil(new_size_ori);
    Nodata=255;
    Nodata=0;
    ImaOUT=zeros(new_size(1),new_size(2),datatype);  % type
    ImaOUT_count=ImaOUT;
    for i=1:new_size(1)
        for j=1:new_size(2)
            if i==new_size(1)
                if floor(new_size_ori(1))~=ceil(new_size_ori(1))
                    x_start=(i-1)*n+1;
                    x_end=size(ImaIN,1);
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
                    y_start=(j-1)*n+1;
                    y_end=size(ImaIN,2);
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
            d=ImaIN(x_start:x_end,y_start:y_end);        
            [d_row,d_col]=size(d);
            d_level1=d; 
            %% for agemap, 255--no change forest or other type, remove these pixels 
            if max(max(d_level1))==Nodata
                ImaOUT(i,j)=Nodata;
            else
             %% for the rest pixel, average   0-25 + 100
                switch Fct
                    case 1 %% majority        
                        ImaOUT(i,j)=mode(reshape(d_level1,[],1));  
                    case 2 %% mean
                        ImaOUT(i,j)=nanmean(reshape(d_level1,[],1));  
                    case 3 %% sum
                        ImaOUT(i,j)=nansum(reshape(double(d_level1),[],1));  
                        ImaOUT_count(i,j)=length(find(d_level1>0));
                    case 4 %% area-weighted mean
                        area_d=area_s(x_start:x_end,y_start:y_end);
                        ImaOUT(i,j)=nansum(reshape(double(d_level1),[],1).*reshape(double(area_d),[],1))/(sum(reshape(double(area_d),[],1)));  %% area-weighted mean 
                    case 5 %% fixed value
                        ImaOUT(i,j)=50;
                    case 6 %% value weighted by area
                        Lat_startth=proj.SpatialRef.LatitudeLimits(2);%-0.5*resoth;
                        Lat_endth=proj.SpatialRef.LatitudeLimits(1);%+0.5*resoth;
                        Long_startth=proj.SpatialRef.LongitudeLimits(1);%+0.5*resoth;
                        Long_endth=proj.SpatialRef.LongitudeLimits(2);%-0.5*resoth;
                        latrange=[Lat_startth:-1:Lat_endth+1];
                        lonrange=[Long_startth:1:Long_endth-1];
                        lats=latrange(i);
                        lons=lonrange(j);
                        lone=lons+1;
                        late=lats-1;
                        area_d=f1_gcsarea(reso,lats,late,lons,lone);
                        %area_d=area_s(x_start:x_end,y_start:y_end);
                        ImaOUT(i,j)=nansum(reshape(double(d_level1).*area_d,[],1));  %% sum
                end
            end
        end
    end
    