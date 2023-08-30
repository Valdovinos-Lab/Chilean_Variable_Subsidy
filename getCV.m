function cv = getCV (timeseries)
    nTimesteps = size(timeseries);
    nSpecies = nTimesteps(2);
    nTimesteps = nTimesteps(1);

    truncates = find(~timeseries(nTimesteps,:));

    cv = zeros(nSpecies,1);

    for i = 1:nSpecies
        if ~any(truncates(:)==i)
            std_temp  = std(timeseries(:,i));
            mean_temp = mean(timeseries(:,i));
            
            cv(i) = std_temp/mean_temp;
        else
            vec_temp = timeseries(:,i);
            vec_temp = vec_temp(find(vec_temp));
            std_temp  = std(vec_temp);
            mean_temp = mean(vec_temp);

            cv(i) = std_temp/mean_temp;
        end

    end

end