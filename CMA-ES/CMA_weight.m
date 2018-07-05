function w_i = CMA_weight(mu)
w_i = zeros(length(mu),1);
for i = 1:mu
    w_i(i) = (log(mu+1) - log(i))/(mu*log(mu+1)-log(factorial(mu)));
end

end