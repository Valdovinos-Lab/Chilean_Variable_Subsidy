function updownplot
    load Data\ChileanIntertidal_ECIMBiomass_massbalance4.mat 
    C = Data.communityMatrix;

    load output/yr2003kmixtenth;
    load output/yr2003kmix1;
    load output/yr2003kmix10;
    
    clf;

    outputtenth = yr2003kmixtenth;
    output1  = yr2003kmix1;
    output10 = yr2003kmix10;

    index = 100;
    xr = [5832,8760];

    hold off
    subplot(3,1,1);
    plot(outputtenth(:,index),'LineWidth',2)
    hold on
    plot(output1 (:,index),'LineWidth',2)
    plot(output10(:,index),'LineWidth',2)
    xlim(xr);
    ylim([0,1])
    ylabel("Onchidella sp.")
    set(gca,'XTick',[6552,7296,8016])
    set(gca,'XTickLabel',['Oct 1';'Nov 1';'Dec 1'])

    subplot(3,1,2);
    down = foodwebconnectionsdown(C,index);
    down = down(down~=index);
    if ~isempty(down)
        resourceplottenth = getSummedBiomass(outputtenth,down);
        plot(resourceplottenth,'LineWidth',2);
        hold on
        resourceplot1 = getSummedBiomass(output1,down);
        plot(resourceplot1,'LineWidth',2);
        resourceplot10 = getSummedBiomass(output10,down);
        plot(resourceplot10,'LineWidth',2);

        xlim(xr);
        %ylim([0,150000]);
        ylabel("Resource Biomass g/m^2")
        set(gca,'XTick',[6552,7296,8016])
        set(gca,'XTickLabel',['Oct 1';'Nov 1';'Dec 1'])
    else
        xlim([0,9000]);
        txt = {'No resource species'};
        text(4,0.5,txt)
    end

    subplot(3,1,3);
    up = foodwebconnectionsup(C,index);
    up = up(up~=index);
    if ~isempty(up)
        predatorplottenth = getSummedBiomass(outputtenth,up);
        plot(predatorplottenth,'LineWidth',2);
        hold on
        predatorplot1 = getSummedBiomass(output1,up);
        plot(predatorplot1,'LineWidth',2);
        predatorplot10 = getSummedBiomass(output10,up);
        plot(predatorplot10,'LineWidth',2);



        xlim(xr);
        %ylim([0,1]);
        ylabel("Predator Biomass g/m^2")
        set(gca,'XTick',[6552,7296,8016])
        set(gca,'XTickLabel',['Oct 1';'Nov 1';'Dec 1'])
    else
        xlim([0,9000]);
        txt = {'No predator species'};
        text(4,0.5,txt)
    end
end
