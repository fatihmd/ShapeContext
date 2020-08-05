function cost = h_cost(s1,s2)

cost=0.5*sum(((s1-s2).^2)./(s1+s2+eps),'all');