library(ggplot2)
library(dplyr)

# Call format:
# Rscript make_plots.R plot_name


#plot.name <- commandArgs(trailingOnly = TRUE)[1]
#file.name

data <- read.csv('data/test_binsize.csv') %>% tbl_df()

size.labels <- 20 * 2^seq(2, 8, length.out = 4)

random.profile <- ggplot(data, aes(x = bucket_size, y = time_ns)) + geom_point() + 
  scale_x_log10(breaks = size.labels) + 
  scale_y_log10() + 
  geom_smooth(method="lm") + 
  labs(title = "Random Access Latency on Will's Computer with Bucket Size 200",
       x = "Number of Accesses Per Bin", y = "Average Latency in Nanoseconds")

ggsave(random.profile, file="plots/out/binsize.pdf")
