function [output] = f_fitfunction(input)               
% test10 logistic curve                                   % a/(1+b*exp(-c*(x)))
% test 11 M-M model                                        a*x/(b+x)
% test 12 Chapman-Richards function                        a*(1-exp(-b*x))^c 
%% extract the parameter
% input={type,testnum,zeroidx, xvalue,yvalue,xori,yori,agbeqpre,agb_iflnear,agenum};
type=input{1}; % function
testnum=input{2}; % 1-all 3-median
zeroidx=input{3}; % zeroidx 1-pass0 2-no pass0
xvalue=input{4};
yvalue=input{5};
xori=input{6};
yori=input{7};
agbeqpre=input{8};
agb_iflnear=input{9};
agenum=input{10};
%% Fit: 'prepare the data'.
if testnum==3
    [xData, yData] = prepareCurveData( xvalue, yvalue );
end
if testnum==1
    [xData, yData] = prepareCurveData( xori, yori );
end
ifl=yData(xData==agenum);
bprevalue=0.02;
rmidx=0;
if ~isnan(agbeqpre) && agbeqpre>0
    a=agbeqpre;
else
    a=agb_iflnear;
end

%%
if zeroidx==1 %standreplacing
    switch type        
        case 10
            % Amax=a*b/(1+b)
            ft = fittype( 'a.*(1+b)./b./(1+b*exp(-c*(x)))-a./(b)', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares','Lower', [0 0 0],'Upper', [2.*a Inf 1] );
            opts.StartPoint = [a 10 0.05];
            [fitresult, gof] = fit( xData, yData, ft, opts);
            bestbeta=[fitresult.a fitresult.b fitresult.c];
            predfun = @(beta)beta(1).*(1+beta(2))./beta(2)./(1+beta(2).*exp(-beta(3).*xData))-beta(1)./beta(2);
            agbeq=fitresult.a;
            [t50] = f_rectime(type,0.5,fitresult.a, fitresult.b, fitresult.c,0,zeroidx);
            [t90] = f_rectime(type,0.9,fitresult.a, fitresult.b, fitresult.c,0,zeroidx);
            curvepara=[fitresult.a.*(1+fitresult.b)./fitresult.b fitresult.b fitresult.c 0  t50 t90 agbeq];      
        case 102
            opts = fitoptions( 'Method', 'NonlinearLeastSquares','Lower', [0 0],'Upper', [Inf 1]);
            opts.StartPoint = [10 0.05];
            ft = fittype( @(b,c,x) a.*(1+b)./b./(1+b.*exp(-c.*x))-a./(b), 'independent', 'x', 'dependent', 'y'  );
            [fitresult, gof] = fit( xData, yData, ft, opts);
            bestbeta=[fitresult.b fitresult.c];
            predfun = @(beta)a.*(1+beta(1))./beta(1)./(1+beta(1).*exp(-beta(2).*xData))-a./(beta(1));
            agbeq=a;
            [t50] = f_recoverytime(type,0.5,a, fitresult.b, fitresult.c,0,zeroidx);
            [t90] = f_recoverytime(type,0.9,a, fitresult.b, fitresult.c,0,zeroidx);
            curvepara=[a.*(1+fitresult.b)./fitresult.b fitresult.b fitresult.c 0 t50 t90 agbeq];
        case 11
            ft = fittype( 'a*x/(b+x)', 'independent', 'x', 'dependent', 'y' );           
            opts = fitoptions( 'Method', 'NonlinearLeastSquares','Lower', [0 0],'Upper', [2.*a 500] );
            opts.StartPoint = [a 20];
            [fitresult, gof] = fit( xData, yData, ft, opts);
            bestbeta=[fitresult.a fitresult.b ];
            predfun = @(beta)(beta(1).*xData./(beta(2)+xData));
            agbeq=fitresult.a;
            [t50] = f_recoverytime(type,0.5,fitresult.a, fitresult.b, 0,0,zeroidx);
            [t90] = f_recoverytime(type,0.9,fitresult.a, fitresult.b, 0,0,zeroidx);
            curvepara=[fitresult.a fitresult.b 0 0  t50 t90 agbeq];
        case 112
            opts = fitoptions( 'Method', 'NonlinearLeastSquares','Lower', [0],'Upper', [500] );
            opts.StartPoint = [20];
            ft = fittype( @(b,x) a.*x./(b+x), 'independent', 'x', 'dependent', 'y'  );
            [fitresult, gof] = fit( xData, yData, ft, opts);
            bestbeta=[ fitresult.b ];
            predfun = @(beta)(a.*xData./(beta(1)+xData));
            agbeq=a;
            [t50] = f_recoverytime(type,0.5,a, fitresult.b, 0,0,zeroidx);
            [t90] = f_recoverytime(type,0.9,a, fitresult.b, 0,0,zeroidx);
            curvepara=[a fitresult.b 0 0 t50 t90 agbeq];
        case 12
            opts = fitoptions( 'Method', 'NonlinearLeastSquares','Lower', [0 0 0],'Upper', [2.*a 0.5 Inf]  );
            opts.StartPoint = [agb_iflnear bprevalue,1];
            ft = fittype( @(a,b,c,x) a*((1-exp(-b*x)).^c), 'independent', 'x', 'dependent', 'y'  );
            [fitresult, gof] = fit( xData, yData, ft, opts);
            bestbeta=[fitresult.a fitresult.b fitresult.c];
            predfun = @(beta)beta(1).*(1-exp(-beta(2).*xData)).^beta(3);
            agbeq=fitresult.a;
            [t50] = f_recoverytime(type,0.5,fitresult.a, fitresult.b, fitresult.c,0,zeroidx);
            [t90] = f_recoverytime(type,0.9,fitresult.a, fitresult.b, fitresult.c,0,zeroidx);
            curvepara=[fitresult.a fitresult.b fitresult.c 0  t50 t90 agbeq];
        case 122
            opts = fitoptions( 'Method', 'NonlinearLeastSquares','Lower', [0 1],'Upper', [0.5 Inf]...
                ,'MaxFunEvals',100000,'MaxIter',100000);
            opts.StartPoint = [bprevalue,1];
            ft = fittype( @(b,c,x) a*((1-exp(-b*x)).^c), 'independent', 'x', 'dependent', 'y'  );
            [fitresult, gof] = fit( xData, yData, ft, opts);
            agbeq=a;
            [t50] = f_recoverytime(type,0.5,a, fitresult.b, fitresult.c,0,zeroidx);
            [t90] = f_recoverytime(type,0.9,a, fitresult.b, fitresult.c,0,zeroidx);
            curvepara=[a fitresult.b fitresult.c 0 t50 t90 agbeq];
            bestbeta=[fitresult.b fitresult.c];
            predfun = @(beta)a.*(1-exp(-beta(1).*xData)).^beta(2);
    end
end
% [bestbeta,r,J,cov,mse] = nlinfit(xData,yData,mdl,a0);
[bestbeta,se,~,~]=f_calse(xData,yData,xvalue,yvalue,bestbeta,predfun);
%% output
output={fitresult,gof,curvepara,agbeq,predfun,bestbeta,se};

end

