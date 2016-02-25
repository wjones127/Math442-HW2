library(ggplot2)
library(dplyr)
library(rstan)

# Call format:
# Rscript model_l1_l2.R

data <- read.csv('data/test_model.csv') %>% tbl_df()

# let's take a smaller sample of the data
data <- data[sample(1:nrow(data), size=1e3, replace=FALSE),]

# todo: rescale variables.... log scale?

# Package the data for stan
model_data = list(
  N = nrow(data)
  , iters = data$bucket_size
  , s = data$size
  , t = data$time_ns
)

#compile the model (takes a minute or so)
model = rstan::stan_model(file="plots/model_l1_l2.stan")

#evaluate the model
sampling_iterations = 2e3 #best to use 1e3 or higher
out = rstan::sampling(
  object = model
  , data = model_data
  , chains = 1
  , iter = sampling_iterations
  , warmup = sampling_iterations/2
  , refresh = sampling_iterations/10 #show an update @ each %10
  , seed = 1
  , init = list(list(tL1 = 2,
                tL2 = 3,
                tL3 = 5,
                tRAM = 100,
                cL1 = 128,
                cL2 = 200000,
                cL3 = 3e6,
                cRAM = 5e9,
                delta = 3,
                epsilon = 3,
                sigma = 1))
)

#print a summary table
print(out)
