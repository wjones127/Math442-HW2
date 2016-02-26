library(ggplot2)
library(dplyr)

# Call format:
# Rscript make_plots.R plot_name
#plot.name <- commandArgs(trailingOnly = TRUE)[1]
#file.name

#seq.data <- read.csv('data/test1.csv') %>%
#  mutate(method = "sequential") %>%
#  tbl_df()
rand.data <- read.csv('data/test_random_ifj.csv') %>%
  mutate(method = "random") %>%
  tbl_df()

size.labels <- c(2^12,
                 2^16,
                 2^20,
                 2^24,
                 2^28,
                 2^32)

random.profile <- ggplot(rand.data, aes(x = size, y = time_ns)) + geom_point() + 
  scale_x_log10(breaks = size.labels) + 
  scale_y_log10() + 
  #geom_smooth() + 
  geom_vline(aes(xintercept = 512000)) + 
  geom_vline(aes(xintercept = 3e6)) +
  geom_vline(aes(xintercept = 4e9)) +
 # geom_vline(aes(xintercept = 8129644000)) + 
  labs(title = "Random Access Latency on Isabella's Computer with Bucket Size 200",
       x = "Size in Bytes", y = "Average Latency in Nanoseconds")

ggsave(random.profile, file="random_ifj2.png")
