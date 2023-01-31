function output = getSummedBiomass (timeseries, indices)
    
    output = timeseries(:,indices(1));

    for i = 2: length(indices)
        output = output + timeseries(:,indices(i));
    end
        
end