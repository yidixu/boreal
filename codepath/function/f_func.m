function [cout] = f_func(test,age,a,tau,b,c,d,zeroidx)
% given the test,age and other information. then do the biomass calculation

% test10 logistic curve                                    a/(1+b*exp(-c*(x)))-a/(1+b)
% test 11 M-M model                                        a*x/(b+x)
% test 12 Chapman-Richards function                        a[1 âˆ? exp(âˆ’b*x)]^cæˆ–è?…ä¸�æˆ�c

cout=zeros(length(a),1);
tic
if zeroidx==1
    if test==2||test==3
        cout=a.*(1-exp(-double(age)./tau));
    elseif test==12 || test==122 || test==12295 || test==1295
        cout=a.*((1-exp(-double(age)./tau)).^c);
    elseif test==11 || test==112 || test==11295 || test==1195
        cout=a.*double(age)./(b+double(age));
    elseif test==10 || test==102  || test==10295 || test==1095
        cout=a./(1+b.*exp(-c.*double(age)))-a./(1+b);
    elseif test==9 || test==92
        cout=a.*exp(-b.*c.^double(age))-a.*exp(-b);  %+d
    end
end

end
