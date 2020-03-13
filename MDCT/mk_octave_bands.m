function top_bin = mk_octave_bands(N)
    for i=1:log2(N)
        top_bin(i) = 2^i;
    end
end