function [B] = binom(n,p)

B = factorial(n)/(factorial(p)*factorial(n-p));

end