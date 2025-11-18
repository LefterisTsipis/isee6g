function PL = MNLOS(d)
d = d ./ 1000;
SdB = 10;
GtdBi = 15;
PL = 128.1 + 37.6 * log10(d) + SdB - GtdBi;
end 