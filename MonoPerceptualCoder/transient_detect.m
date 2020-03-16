function [flag, onset_idx] = transient_detect(x, hp_b, hp_a)

    common;
    
    %enumerate sets of short segments within input signal x
    short0 = 1:4;   %before short windows
    short1 = 5:8;   %first 4 short windows
    short2 = 9:12;  %last 4 short windows
    short3 = 13:16; %after short windows
    %deemed to be ?silence?
    rms_x = rms(x);
    flag = 0;
    onset_idx = 0;
    if rms_x < 100/32768
        
        return;
    end 
    
    % High-Pass filter the function's input signal.
    filtered_x = filter(hp_b,hp_a,x);
   
    
   
    % Compute the power in each of the sixteen 128-sample contiguous non-
    % overlapping intervals of the high-pass filtered segment.Each SHORT window is 256
    %sample in length, with 128-sample overlap with its adjacent windows.
    for i = 0:15
        pow_x_buf(i+1) = sum(filtered_x(i*NS2+1:i*NS2+128).^2) / NS2;  
    end
    
    %Compute the average power in the four sets of the 16 intervals, with the four
    %sets indicated by the following variables. Let these power values be p0, p1, p2, p3.
    
    
        p0 = mean(pow_x_buf(1:4));
        p1 = mean(pow_x_buf(5:8));
        p2 = mean(pow_x_buf(9:12));
        p3 = mean(pow_x_buf(13:16));
    %Compute the ratio of the power of p1/p0, p2/p1 and p3/p2. If these power
    %ratios are large, it indicates an increase in signal power as in a signal
    %transient. In your code, protect from division by zero, i.e. if p0 is zero,
    %don?t divide but just set the ratio to 0.
        ratio1o0 = p1/p0;
        ratio2o1 = p2/p1;
        ratio3o2 = p3/p2;
        
        if p0 == 0 
            ratio1o0 = 0;
        elseif p1 == 0
            ratio2o1 = 0;
        elseif p2 == 0
            ratio3o2 = 0;  
        end
    %If either of p1/p0 or p2/p1 is greater than a threshold WIN_HP_THR 
    %(10, as set in common.m), then
        %Set flag to the value?1?
        %Setonset_idxtotheshortwindownumberwithinshort1andshort2
        %with the greatest signal power. Be sure to - ?4?    
        %so that the first window has an index ?1?.
    if ratio1o0 > WIN_HP_THR || ratio2o1 > WIN_HP_THR
            flag = 1;
            [maxVal,maxIdex] = max(pow_x_buf(5:12));
            onset_idx = maxIdex;
    end
    
end
