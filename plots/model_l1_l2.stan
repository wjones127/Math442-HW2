 data {
	int<lower=1> N; # num of observations
	vector<lower=0>[N] iters; # log of num of iterations
	vector<lower=1>[N] s; # size of byte array
	vector<lower=0>[N] t; # Measured average time
}

parameters {
	real<lower=0> tL1; # L1 cache access time
	real<lower=0> tL2; # L2 cache access time
	real<lower=0> tL3; # L3 cache access time
	real<lower=0> tRAM; # RAM access time
	real<lower=0> cL1; # L1 cache size
	real<lower=0> cL2; # L2 cache size
	real<lower=0> cL3; # L2 cache size
#	real<lower=0> cRAM; # RAM size
	real<lower=0> delta; # time to measure start and end time
#	real<lower=0> k; # hyperparameter for error
#	real<lower=0> error; # error from interruptions
  real<lower=0> sigma; # error in model
}
model {
  # Distribution of data in memory  
  vector[N] pL1; # proportion of bytes in L1 cache
  vector[N] pL2; # proportion of bytes in L2 cache
  vector[N] pL3; # proportion of bytes in L3 cache
  vector[N] pRAM; # proportion of bytes in RAM
  vector[N] inv_iters; 
  vector[N] scaled_error;
  real size_left;
  
	# priors on parameters and hyperparameters
	tL1 ~ gamma(2, 2);
	tL2 ~ gamma(4, 2);
  tL3 ~ gamma(20, 2);
	tRAM ~ gamma(500, 2);
	cL1 ~ normal(35000, 40000); # exp(5.5) = 256
	cL2 ~ normal(400000, 4000000); # exp(12.61) = 300,000
	cL3 ~ normal(4000000, 30000000); # exp(14.91) = 3,000,000
#	cRAM ~ lognormal(21.82, 2); # exp(21.82) = 3,000,000,000
  delta ~ normal(100, 1000);
	#error ~ normal(50, 100);
	sigma ~ gamma(2,2);
     
  # Here, we assume closer caches are filled before other caches are
  for (i in 1:N) pL1[i] <- fmin(1.0, cL1 / s[i]);
  for (i in 1:N) {
    size_left <- s[i] - cL1;
    if (size_left > cL2) {
      pL2[i] <- cL2 / size_left;
    } else {
      pL2[i] <- 1 - pL1[i];
    };
  }
  for (i in 1:N) {
    size_left <- s[i] - cL2 - cL1;
    if (size_left > cL3) {
      pL3[i] <- cL3 / size_left;
    } else {
      pL3[i] <- 1 - pL1[i] - pL2[i];
    };
  }
  for (i in 1:N) {
      pRAM[i] <- 1 - pL1[i] - pL2[i] - pL3[i];
  }
  
  # Compute scaled error
  for (i in 1:N) inv_iters[i] <- 1.0 / iters[i];
  #for (i in 1:N) scaled_error[i] <- error / iters[i];
    
  t ~ normal(pL1*tL1 + pL2*tL2 + pL3*tL3 + pRAM*tRAM + delta * inv_iters, sigma);

}
