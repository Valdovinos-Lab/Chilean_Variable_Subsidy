function [time,fluo] = fluoimport_daily(year)
    
    %read in fluoresence values for given year
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

    %if year in question has no value for jan 1st, load final value from 
    %previous years' dataset 

    %no preceeding year for 1999
    if time(1) ~= 1 && year > 1999

        %load previous years' data
        filename2 = strcat('Chiledata\Chile_',num2str(year-1),'_CSD.xlsx');
        M2 = readmatrix(filename2);
        n2 = length(M2);

        t_final = M2(n2,1)-365*24;
        f_final = M2(n2,2);

        slope = (fluo(1)-f_final)/(time(1)-t_final);
        f_new = fluo(1)-slope*time(1);


        %shift down t vector, and add t=1
        time(2:length(time))=time(1:length(time)-1);
        time(1) = 1;
        %shift down f vector, and add interpolated f at t=1
        fluo(2:length(time))=fluo(1:length(time)-1);
        fluo(1) = f_new;
    end

end
