 data {
	int<lower=1> N; # num of observations
	vector<lower=1>[N] iters; #num of iterations
	int<lower=1> s[N]; # size of byte array
	vector<lower=0>[N] t; # Measured average time
}

parameters {
	real<lower=0> tL1; # L1 cache access time
	real<lower=0> tL2; # L2 cache access time
	real<lower=0> tL3; # L3 cache access time
	real<lower=0> tRAM; # RAM access time
	real<lower=1> cL1; # L1 cache size
	real<lower=1> cL2; # L2 cache size
	real<lower=1> cL3; # L2 cache size
	real<lower=1> cRAM; # RAM size
	real<lower=0> delta; # time to measure start and end time
	real<lower=0> epsilon; # error from interruptions
  real<lower=0> sigma; # error in model
}
model {
  # Distribution of data in memory  
  vector[N] pL1; # proportion of bytes in L1 cache
  vector[N] pL2; # proportion of bytes in L2 cache
  vector[N] pL3; # proportion of bytes in L3 cache
  vector[N] pRAM; # proportion of bytes in RAM
  vector[N] inv_iters;
  
	# priors on parameters and hyperparameters
	tL1 ~ gamma(2, 2);
	tL2 ~ gamma(4, 2);
  tL3 ~ gamma(20, 2);
	tRAM ~ gamma(500, 2);
	cL1 ~ normal(256, 20);
	cL2 ~ normal(300000, 10000);
	cL3 ~ normal(3000000, 100000);
	cRAM ~ normal(4000000000, 3000000000);
	epsilon ~ gamma(2, 2);
	sigma ~ gamma(2,2);
    
  # Here, we assume closer caches are filled before other caches are
  for (i in 1:N) pL1[i] <- fmin(1.0, cL1 / s[i]);
  for (i in 1:N) pL2[i] <- fmin(1.0, cL2 / (s[i] - cL1));
  for (i in 1:N) pL3[i] <- fmin(1.0, cL3 / (s[i] - cL1 - cL2));
  for (i in 1:N) pRAM[i] <- fmin(1.0, cRAM / (s[i] - cL1 - cL2 - cL3));
  
  # Compute inverse of iters
  for (i in 1:N) inv_iters[i] <- 1 / iters[i];
    
  t ~ normal(pL1*tL1 + pL2*tL2 + pL3*tL3 + pRAM*tRAM + (delta + epsilon) * inv_iters, sigma);

}
