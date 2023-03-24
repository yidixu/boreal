function [fitAGB,me,sg,med,q25,q75] = f_montecarlo(bestbeta,se,a_ifl,typefreq,xall,iter,zeroidx)
%F_MONTECARLO Summary of this function goes here
%   Detailed explanation goes here
fitAGB=[];
frequency=iter; % 100000 
for ai=1:length(xall)
    agei=xall(ai);
    for i=1:frequency
        if zeroidx==1 %standreplacing
            if typefreq==12
                a=normrnd(bestbeta(1),se(1));
                b=normrnd(bestbeta(2),se(2));
                c=normrnd(bestbeta(3),se(3));
                tp=a.*(1-exp(-b.*agei)).^c  ;
            end
            if typefreq==122 chaplin-Kramer curve  @   predfun = @(beta)beta(1)-beta(2).*exp(-beta(3).*xData);
                b=normrnd(bestbeta(1),se(1));
                c=normrnd(bestbeta(2),se(2));
                if b<=0 || c<=0
                    tp=nan;
                else
                    tp=a_ifl.*(1-exp(-b.*agei)).^c  ;
                end
                %tp
            end
            if typefreq==11
                a=normrnd(bestbeta(1),se(1));
                b=normrnd(bestbeta(2),se(2));
                tp=a.*double(agei)./(b+double(agei));
            end
            if typefreq==112
                b=normrnd(bestbeta(1),se(1));
                tp=a_ifl.*double(agei)./(b+double(agei));
            end
            if typefreq==10
                a=normrnd(bestbeta(1),se(1));
                b=normrnd(bestbeta(2),se(2));
                c=normrnd(bestbeta(3),se(3));
                tp=a./(1+b.*exp(-c.*double(agei)))-a/(1+b);
            end
            if typefreq==102
                b=normrnd(bestbeta(1),se(1));
                c=normrnd(bestbeta(2),se(2));
                tp=a_ifl./(1+b.*exp(-c.*double(agei)))-a_ifl/(1+b);
            end         
        else %non standreplacing
            if typefreq==12
                a=normrnd(bestbeta(1),se(1));
                b=normrnd(bestbeta(2),se(2));
                c=normrnd(bestbeta(3),se(3));
                d=normrnd(bestbeta(4),se(4));
                tp=(a-d).*(1-exp(-b.*agei)).^c + d  ;  
            end
            if typefreq==122
                b=normrnd(bestbeta(1),se(1));
                c=normrnd(bestbeta(2),se(2));
                d=normrnd(bestbeta(3),se(3));
                if b<=0 || c<=0 || d<=0
                    tp=nan;
                else
                    tp=(a_ifl-d).*(1-exp(-b.*agei)).^c + d ;
                end
            end
            if typefreq==11
                a=normrnd(bestbeta(1),se(1));
                b=normrnd(bestbeta(2),se(2));
                c=normrnd(bestbeta(3),se(3));
                tp=(a-c).*double(agei)./(b+double(agei))+c;
            end
            if typefreq==112
                b=normrnd(bestbeta(1),se(1));
                c=normrnd(bestbeta(2),se(2));
                tp=(a_ifl-c).*double(agei)./(b+double(agei))+c;
            end
            if typefreq==10
                a=normrnd(bestbeta(1),se(1));
                b=normrnd(bestbeta(2),se(2));
                c=normrnd(bestbeta(3),se(3));
                tp=a./(1+b.*exp(-c.*double(agei)));
            end
            if typefreq==102
                b=normrnd(bestbeta(1),se(1));
                c=normrnd(bestbeta(2),se(2));
                tp=a_ifl./(1+b.*exp(-c.*double(agei)));
            end
        end
        fitAGB(i,ai)=real(tp);
    end
end
fitAGB(fitAGB==Inf|fitAGB==-Inf)=nan;
me=nanmean(fitAGB);
ma=nanmax(fitAGB);
mi=nanmin(fitAGB);
sg=nanstd(fitAGB);
med=nanmedian(fitAGB);
q25=quantile(fitAGB,0.25);
q75=quantile(fitAGB,0.75);
end

