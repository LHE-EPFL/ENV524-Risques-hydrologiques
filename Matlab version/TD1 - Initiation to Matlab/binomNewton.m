function [Z] = binomNewton(n,x,y)

z = zeros(1,n);

for j = 1 : n+1
    k = j-1;
    z(j) = binom(n,k)*x^(n-k)*y^k;
end
Z = sum(z);

end