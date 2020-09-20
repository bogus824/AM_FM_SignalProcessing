function [fftvalues] = fftfunction(x)

signal = x;
N = length(signal);
samples = 1:N;


for l=samples

tempexp = exp(-j*2*pi*(l-1)*(samples-1)/N);
X(l) = (sum(signal.*tempexp));


fftvalues = X;


end

end