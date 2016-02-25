 data {
	int<lower=1> N; # num of observations
	int<lower=1> iters[N]; #num of iterations
	int<lower=1> s[N]; # size of byte array
	vector<lower=0>[N] t; # Measured average time
}
parameters {
	real<lower=0> tL1; # L1 cache access time
	real<lower=0> tL2; # L2 cache access time
	real<lower=1> cL1; # L1 cache size
	real<lower=1> cL2; # L2 cache size
	real<lower=0> delta; # time to measure start and end time
	real<lower=0> epsilon; # error from interruptions
  real<lower=0> sigma; # error in model
}
transformed parameters {
#	real<lower=0,upper=1> pL1[N]; # proportion of bytes in L1 cache
#  real<lower=0,upper=1> pL2[N]; # proportion of bytes in L2 cache
  
    # Sepecify model for proportion of bytes in each cache
#  for (i in 1:N)
#    pL1[i] <- fmin(1.0, cL1 / s[i] );
#  for (i in 1:N)
#    pL2[i] <- fmin(1.0, cL2 / (s[i] - pL1[i]));
}
model {
	# priors on parameters and hyperparameters
	tL1 ~ gamma(2, 2);
	tL2 ~ gamma(4, 2);
	cL1 ~ normal(256, 20);
	cL2 ~ normal(300000, 1000);
	#delta ~ normal(10, 2);
	epsilon ~ gamma(2, 2);
	sigma ~ gamma(2,2);
	

  # Sepecify model for number of bytes in each cache
  #for (i in 1:N)
  #  nL1[i] ~ binomial(s[i], fmin(1.0, cL1 / s[i] ));
  #for (i in 1:N)
  #  nL2[i] ~ binomial(s[i] - nL1[i], fmin(1, cL2 / (s[i] - nL1[i]) ));
    
    
  # Specify time model
  for (i in 1:N)
    t[i] ~ normal(fmin(1.0, cL1 / s[i] ) * tL1 +
                  fmin(1.0, cL2 / (s[i] - fmin(1.0, cL1 / s[i] ))) * tL2 + 
                  (delta + epsilon)/iters[i], sigma);


}
