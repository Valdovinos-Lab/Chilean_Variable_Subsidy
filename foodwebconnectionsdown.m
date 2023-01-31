function output = foodwebconnectionsdown(C, index)

%Input a community matrix and a list of indices
%Returns vector of indices that this list of organisms consume

output = find(C(index(1),:));

leng = length(index);

for i = 2:leng
    output = [output,find(C(index(i),:))];
end

output = unique(sort(output));


