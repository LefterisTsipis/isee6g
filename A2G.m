function PLdB = A2G(r, h)
    c = 3e8;
    f = 2e9;
    a = 9.61;
    b = 0.16;
    d = sqrt((r.^2) + (h.^2));
    theta = atan(h ./ r);
    hNLoS = 20;
    hLoS = 1;
    PLoS = 1 ./ (1 + a .* (exp(-b .* ((180./pi) .* theta - a))));
    PNLoS = 1 - PLoS;
    PLdB = 20 .* log10((4 .* pi .* f .* d) ./ c) + PLoS .* hLoS + PNLoS .* hNLoS;
end


