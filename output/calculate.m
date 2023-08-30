function cov = calculate(output)
    %remove zeroes from after extinction
    for i = 1:108
        vector = output(:,i);
        vector = nonzeros(vector);
        avg(i)   = mean(vector);
        stdev(i) = std(vector);
    end

    avg = transpose(avg);
    stdev = transpose(stdev);
    
    cov = stdev./avg;
end
