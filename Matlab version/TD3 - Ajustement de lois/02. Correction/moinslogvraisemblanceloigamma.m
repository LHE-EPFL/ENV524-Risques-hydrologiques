
function lvrai = moinslogvraisemblanceloigamma(lambda,k,x)

lvrai=lambda.*sum(x)-length(x).*log(lambda.^k./gamma(k))-(k-1).*sum(log(x));

end




