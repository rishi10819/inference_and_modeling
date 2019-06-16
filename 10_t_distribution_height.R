library(dslabs)
library(dplyr)
data(heights)

# generate 'x', a vector of male heights
x <- heights %>% 
  filter(sex == "Male") %>%
  .$height


mu <- mean(x) # mean height
N <- 15       # sample size
B <- 10000    # number of times the simulation should run

# make sure your answer matches the expected result after random sampling
set.seed(1)

# Generate a logical vector 'res' that contains the results of the simulations
res <- replicate(B, {
  X <- sample(x, N, replace=TRUE)
  interval <- mean(X) + c(-1,1)*qnorm(0.975)*sd(X)/sqrt(N)
  between(mu, interval[1], interval[2])
})

# proportion of times the simulation produced values within the 95% confidence interval.
mean(res) # 0.9323

###########################################

# mean of filtered heights x
mu <- mean(x)

# make sure your answer matches the expected result after random sampling
set.seed(1)

# Generate a logical vector 'res' that 
# contains the results of the simulations using the t-distribution
res <- replicate(B, {
  X <- sample(x, N, replace=TRUE)
  interval <- mean(X) + c(-1,1)*qt(0.975, N-1)*sd(X)/sqrt(N)
  between(mu, interval[1], interval[2])
})

# proportion of times the simulation produced values within the 95% confidence interval.
mean(res) # 0.9523

###########################################