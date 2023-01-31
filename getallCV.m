function output = getallCV(timeseries)
    load Data\ChileanIntertidal_ECIMBiomass_massbalance4.mat

    TL = {Data.Guilds.TL};
    
    
    iProd = find(strcmpi(TL,'''producers'''));
    iFF   = find(strcmpi(TL,'''Filter'''));
    iHerb = find(strcmpi(TL,'''Herbivore'''));
    iOmni = find(strcmpi(TL,'''Omnivore'''));
    iPred = find(strcmpi(TL,'''Predator'''));
    iTop  = find(strcmpi(TL,'''Top'''));

    %offshore phytoplankton
    output(1) = getCV(timeseries, 108);
    %foodweb + baseline phytoplanktkon
    output(2) = getCV(timeseries, [95,107]);
    %non-phytoplankton producers
    output(3) = getCV(timeseries, iProd);
    %filter-feeders
    output(4) = getCV(timeseries, iFF);
    %herbivores
    output(5) = getCV(timeseries, iHerb);
    %omnivores
    output(6) = getCV(timeseries, iOmni);
    %carnivores
    output(7) = getCV(timeseries, iPred);
    %top predators
    output(8) = getCV(timeseries, iTop);

end