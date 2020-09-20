function [ifftvalues] = ifftfunction(x)

signal = x;
N = length(signal);
samples = 1:N;


for l=samples

tempexp = exp(j*2*pi*(l-1)*(samples-1)/N);
X(l) = 1/N*(sum(signal.*tempexp));


ifftvalues = X;


end

end