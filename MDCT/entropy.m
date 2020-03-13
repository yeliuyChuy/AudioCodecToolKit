function h = entropy(x_idx)

    x_idx = reshape(x_idx,[],1);
    v = unique(x_idx);      % Gathers all unique values
    m = length(v);
    
    for i=1:m
          %count number of occurrences
          p(i) = sum(x_idx == v(i));

     end
     p = (p/sum(p))'; %now p is probability
     noneZero=nonzeros(p);            
     h=-sum(noneZero.*log2(noneZero)); %equates entropy

end
    