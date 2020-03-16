function test_quant_iquant_pmr()
%{
A positive-valued mid-rise quantizer has no negative inputs or outputs. 
What is new about the mid-rise quantizer is that a zero input results in a ?half-stepsize? output. 
This requires that a half-stepsize offset be subtracted from the input value prior to the quantization and rounding steps, 
and that the first quantizer value be mapped to index 0. 
Upon reconstruction, the half- stepsize must added to the reconstructed value.
%}

    N = 5;
    x = linspace(0, N, 100);
    qs = 1.0;
    [~, ~, y, ~] = quant_iquant_pmr(x, qs);
    
    ns = x;
    plot(ns, x, 'b', ns, y, 'r');
    grid on
    grid minor
    title('Positive Mid-Rise Quatizer');
    ylabel('Reconstructed Value');
    xlabel('Input value');
end