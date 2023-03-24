function [bestbeta,se,rsquare,rmse]=f_calse(xData,yData,xvalue,yvalue,bestbeta,predfun)
%F_CALSE calculate the para range for monte carlo 
        sse=nansum((predfun(bestbeta)-yData).^2);
        rmse=sqrt(sse/(length(xData)-2));
        rsquare=1-sse/sum((yData-mean(yData)).^2);
        dof = length(find(xvalue(~isnan(yvalue)))) - 2;
        sdr = sqrt(sum((yData - predfun(bestbeta)).^2)/dof);
        J = jacobianest(predfun,bestbeta);
        Sigma = sdr^2*inv(J'*J);
        se = sqrt(diag(Sigma))';
        se(bestbeta-se<0)=bestbeta(bestbeta-se<0);
end

%
%         sse=sum(r.^2);
%         r2=1-sse/sum((yData-mean(yData)).^2);
%         rmse=sqrt(sse/(length(xData)-2));
%         mse;
%         alpha=0.05;
%         ci = nlparci(bestbeta,r,J,alpha); %'Jacobian',J
%         t = tinv(1-alpha/2,length(yData)-length(bestbeta));
%         se = (ci(:,2)-ci(:,1)) ./ (2*t);
%         bestbeta=bestbeta';
