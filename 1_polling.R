# Democrats = p
# Republicans = 1-p

N <- 25 # sample size

p <- seq(0, 1, length = 100)

# standard error of each sample average
se <- sqrt(p*(1-p)/N)

plot(p, se)

###############################################

# The vector `sample_sizes` contains the three sample sizes
sample_sizes <- c(25, 100, 1000)

# Write a for-loop that calculates the standard error `se` for every value of `p` for each of the three samples sizes `N` in the vector `sample_sizes`. Plot the three graphs, using the `ylim` argument to standardize the y-axis across all three plots.
for (i in sample_sizes){
  se <- sqrt(p*(1-p)/i) # generate a vector of standard errors se for all values of p
  plot(p, se)
  ylim = 0:se # to keep the y-axis limits constant across all three plots
}

###############################################

# proportion of Democratic voters
p <- 0.45

# standard error of the spread.
2*sqrt(p*(1-p)/N)  # 0.1989975

###############################################

