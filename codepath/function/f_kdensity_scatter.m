function [ax]=f_kden_scatter(X,Y)
    
%%     this is the function to plot the kdensity scatter plot
%%     X=estimate;
%%     Y=observe;

    c = ksdensity([X,Y], [X,Y]);
    colormap('Jet');
    si=scatter(X,Y, 5, c, 'filled');
    si.MarkerFaceAlpha=0.5
    [r2,rmse,NRMSE,mse,mae,mape,nrmse_range,diso] = yd_sta(Y,X);
    p = polyfit(X(:,1), Y(:,1), 1);
    mdl = fitlm(X(:,1), Y(:,1));
    y_pred = predict(mdl, X(:,1));
    residuals = Y(:,1) - y_pred;
    hold on
    slope = p(1);
    disp(['slope: ' num2str(slope)]);
    intercept = p(2);
    ymax=round(max(Y)./100)*100;
    xfit = 0:ymax;
    yfit = slope*xfit + intercept;
    hold on
    plot( xfit, yfit, 'k-','LineWidth',1) %kk
    hold on
    ydef=xfit;
    plot( xfit, ydef, 'k--','LineWidth',1) % 1:1 line
    legend('','Linear regression line','1:1 line','Location','northwest') %1:1 line
    legend boxoff
    colorbar;
    ylabel('AGB_s_i_t_e (Mg ha^-^1)')
    xlabel(strcat('AGB_c_u_r_v_e (Mg ha^-^1)'))
    ax = gca;
    ax.TitleHorizontalAlignment = 'left';
    axis([0,ymax,0,ymax])
    axis square
    set(gca,'xtick',(0:ymax/(ymax/100):ymax),'ytick',(0:ymax/(ymax/100):ymax))
    k=[0.55,0.15];
    x0=0+k(1)*(ymax-0);%
    y0=0+k(2)*(ymax-0);%
    text(x0,y0,sprintf('r = %g\nRMSE = %g\nN = %g\nDISO = %g\nslope = %g\n',roundn(sqrt(r2),-1),roundn(rmse,-1),roundn(size(X,1),-1),roundn(diso,-2),roundn(slope,-1)),'FontSize',11)
    box on
end