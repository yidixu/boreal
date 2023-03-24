function [tprop] = f_recoverytime(test,prop,aall,ball,call,dall,zeroidx)
% this is to calculate the recovery time
% test10 logistic curve                                    a/(1+b*exp(-c*(x)))-a/(1+b)
% test 11 M-M model                                        a*x/(b+x)
% test 12 Chapman-Richards function                        a*[(1-exp(-b*x))]^c
tprop=zeros(length(aall),1);
tic
if zeroidx==1 %standreplacing
    if test==12 || test==122
        tprop=real(-log(1-nthroot(prop,call))./ball);
    elseif  test==11 || test==112
        tprop=real(ball.*prop./(1-prop));
    else
        for pi=1:length(aall)
            a=aall(pi);
            b=ball(pi);
            c=call(pi);           
            if test==10 || test==102
                syms x;
                eqn=a.*(1+b)./b./(1+b.*exp(-c.*x))-a./b==prop.*a;
                temp=double(solve(eqn,x,'Real',true));
                tprop(pi)=temp(1);
            end
            if mod(pi,100)==0 %&& j>5000
                T_time=toc;
                fprintf(' in process...pi= [%s/%s],. in %s seconds,.\r',num2str(pi),num2str(length(a)),num2str(T_time));
            end
        end
    end
else %non-standreplacing
    for pi=1:length(aall)
        a=aall(pi);
        b=ball(pi);
        c=call(pi);
        d=dall(pi);
        if test==12 || test==122
            syms x;
            eqn=(a-d).*((1-exp(-b.*x))).^c+d==prop.*(a-d)+d;
            temp=double(solve(eqn,x,'Real',true)) ;
        end
        if test==11 || test==112
            syms x;
            eqn=((a-c).*x./(x+b)+c)==prop.*(a-c)+c;
            temp=double(solve(eqn,x,'Real',true));
        end      
        if test==10 ||test==102
            syms x;
            eqn=a./(1+b.*exp(-c.*x))==prop.*a+(1-prop)*a./(1+b);
            temp=double(solve(eqn,x,'Real',true));
        end
        tprop(pi)=temp(1) ;      
        if mod(pi,100)==0 %&& j>5000
            T_time=toc;
            fprintf(' in process...pi= [%s/%s],. in %s seconds,.\r',num2str(pi),num2str(length(a)),num2str(T_time));
        end
    end
end
end
