
# get the average value of a randomly sampled population.
# generates our estimate, X-bar.

take_sample <- function(p, N){
  X <- sample(c(0,1), size = N, replace = TRUE, prob = c(1 - p, p))
  mean(X)
}

# make sure your answer matches the expected result after random sampling
set.seed(1)

# proportion of Democrats in the population being polled
p <- 0.45

# number of people polled
N <- 100

# Call the `take_sample` function to determine the sample average of `N` randomly selected people 
take_sample(p,N) # 0.46

############################################

# number of times we want the sample to be replicated
B <- 10000

# make sure your answer matches the expected result after random sampling
set.seed(1)

# replicate, subtracting the result of `take_sample` function from `p` for `B` replications
errors_1 <- replicate(B, {
  X <- p - take_sample(p,N)
  mean(X)  
})

mean(errors_1) # -4.9e-05

############################################

# make sure your answer matches the expected result after random sampling
set.seed(1)

errors_2 <- replicate(B, p - take_sample(p, N))

# Calculate the mean of the absolute value of each simulated error. 

mean(abs(errors_2)) # 0.039267

############################################

# Calculate the standard deviation of `errors`

sqrt(mean(abs(errors_2)^2)) # 0.04949939

############################################

# standard error
sqrt(p * (1-p) / N) # 0.04974937

############################################

# make sure your answer matches the expected result after random sampling
set.seed(1)

# Define `X` as a random sample of `N` voters with a probability of 
# picking a Democrat ('1') equal to `p`
X <- sample(c(0,1), size = N, replace = TRUE, prob = c(1 - p, p))

# average sampled proportion
X_bar <- mean(X)
# X_bar # 0.46

# standard error of the estimate
sqrt(X_bar * (1-X_bar) / N) # 0.04983974

############################################

# Generate `errors` by subtracting the estimate from the actual proportion of Democratic voters
errors_3 <- replicate(B, p - take_sample(p, N))

# Generate a qq-plot of `errors` with a qq-line showing a normal distribution
qqnorm(errors_3)
qqline(errors_3)

############################################

# estimating proportion of Democrats in the population is greater than 0.5.

1 - pnorm(0.5, p, sqrt(p*(1-p)/N)) # 0.3076513

############################################

# sample average
X_hat <- 0.51

# standard error of the sample average
se_hat <- sqrt(X_hat*(1-X_hat)/N)

# Calculate the probability that the error is 0.01 or larger
1 - pnorm(.01, 0, se_hat) + pnorm(-0.01, 0, se_hat) # 0.9203284

############################################
