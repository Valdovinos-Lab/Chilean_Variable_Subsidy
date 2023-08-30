function [avg, final, cov] = calculate(output)

    avg = transpose(mean(output));

    final = transpose(output(8761,:));

    stdev = transpose(std(output));

    cov = stdev./avg;
end
