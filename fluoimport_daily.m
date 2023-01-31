function [time,fluo] = fluoimport_daily(year, initial)

    filename = strcat('Chiledata\Chile_',num2str(year),'_CSD.xlsx');
    M = readmatrix(filename);

    n = length(M);
    time = zeros(24*n+1,1);
    fluo = zeros(24*n+1,1);

    for i = 1:n
        for j = 1:24
            time((i-1)*24+j) = (M(i,1)-1)*24+j;
            fluo((i-1)*24+j) = M(i,2);
        end
    end

    if time(1) ~= 1

        time(2:length(time))=time(1:length(time)-1);
        time(1) = 1;

        fluo(2:length(time))=fluo(1:length(time)-1);
        fluo(1) = initial;
    end

end
