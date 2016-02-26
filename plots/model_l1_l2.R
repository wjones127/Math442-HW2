library(ggplot2)
library(dplyr)
#library(rstan)

# Call format:
# Rscript model_l1_l2.R

data <- read.csv('data/test_model.csv') %>% tbl_df()

# Add index array size
data$total_size <- data$size + 4 * data$bucket_size

# Create dataframe of minimums
data.min <- data %>%
  group_by(size, bucket_size) %>%
  summarise(time_ns_min = min(time_ns)) %>%
  filter(size < 2e6)

model_confirm <- data.min %>%
  filter(size %in% c(4096, 12288, 40960, 32768, 61440, 327680)) %>%
  ggplot(aes(x = 1 / bucket_size, y = time_ns_min, color = as.factor(size))) + 
  geom_point() + 
  labs(title = "Inverse Buccket Size and Access Time for a few Sizes",
       x = "1 / Bucket Size",
       y = "Access Time (ns)",
       color = "Array Size (Bytes)")

ggsave(model_confirm, file="plots/out/model_confirm.png")  

# Add index array size
data.min$total_size <- data.min$size + 4 * data.min$bucket_size

intercept <- function (x, y) {
  lm.data <- data.frame(x,y)
  model <- lm(y~x, data=lm.data)
  return(coef(model)[1])
}

times <- data.min %>%
  group_by(size) %>%
  summarise(time_ns = intercept(1/bucket_size, time_ns_min))

computed_profile <- ggplot(times, aes(x = size, y = time_ns)) + 
  geom_point() + 
  geom_vline(aes(xintercept = 32000), color='blue') + 
  geom_vline(aes(xintercept = 32000 + 256e3), color='blue') +
  geom_vline(aes(xintercept = 3e6 + 32000 + 256e3 ), color='blue') +
  labs(title = "Computed Access Time by Size",
       x = "Array Size (Bytes)",
       y = "Access Time (ns)")

ggsave(computed_profile, file="plots/out/computed_times.png")

# let's take a smaller sample of the data
# data <- data[sample(1:nrow(data), size=1e3, replace=FALSE),]

# Package the data for stan
# model_data <- list(
#   N = nrow(data.min)
#   , iters = data.min$bucket_size
#   , s = data.min$total_size
#   , t = data.min$time_ns_min
# )
# #compile the model (takes a minute or so)
# model <- rstan::stan_model(file="plots/model_l1_l2.stan")
# 
# #evaluate the model
# sampling_iterations = 2e3 #best to use 1e3 or higher
# out <- rstan::sampling(
#   object = model
#   , data = model_data
#   , chains = 1
#   , iter = sampling_iterations
#   , warmup = sampling_iterations/2
#   , refresh = sampling_iterations/10 #show an update @ each %10
#   , seed = 1
#   , init = list(list(tL1 = 2,
#                 tL2 = 3,
#                 tL3 = 5,
#                 tRAM = 100,
#                 cL1 = 300,
#                 cL2 = 20000,
#                 cL3 = 700000,
#                 #cRAM = 20,
#                 delta = 10,
#                 error = 3))
# )
# 
# #print a summary table
# print(out)
