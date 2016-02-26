library(ggplot2)
library(dplyr)

# Call format:
# Rscript make_plots.R plot_name


#plot.name <- commandArgs(trailingOnly = TRUE)[1]
#file.name

data <- read.csv('data/test_binsize_ifj.csv') %>% tbl_df()

size.labels <- 20 * 2^seq(2, 8, length.out = 4)



random.profile <- ggplot(data, aes(x = bucket_size, y = time_ns)) +
    geom_point(alpha = 0.3) + 
  scale_x_continuous(breaks = size.labels) + 
  scale_y_continuous(limits=c(0, 20)) + 
  labs(title = "Average Random Access Latency by Bucket Size",
       x = "Number of Accesses Per Bucket", y = "Average Latency in Nanoseconds")

ggsave(random.profile, file="plots/out/binsize.png")


# Try similar graph with inverse bucket size
data$inv_bucket_size = 1 / data$bucket_size

random.profile <- ggplot(data, aes(x = inv_bucket_size, y = time_ns)) +
    geom_point(alpha = 0.3) + 
  scale_x_continuous() + 
  scale_y_continuous(limits=c(0, 20)) + 
  labs(title = "Average Random Access Latency by Inverse Bucket Size",
       x = "Inverse Bucket Size", y = "Average Latency in Nanoseconds")

ggsave(random.profile, file="plots/out/inv_binsize_ifj.png")
