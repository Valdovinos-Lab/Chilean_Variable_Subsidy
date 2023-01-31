function cv = getCV (timeseries,index)
    timesteps = size(timeseries);
    timesteps = timesteps(1);

    omits = find(~timeseries(timesteps,:));

    for i = 1:length(omits)
        index(index==omits(i))=[];
    end

    sum = zeros(timesteps,1);

    for i = 1:length(index)
        sum = sum + timeseries(:,index(i));
    end

    cv = std(sum)/mean(sum);
end