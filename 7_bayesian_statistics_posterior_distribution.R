library(dplyr)
library(dslabs)

data(polls_us_election_2016)
nrow(polls_us_election_2016) # 4208

# spread of predictions for each candidate in Florida during the last polling days
polls <- polls_us_election_2016 %>% 
  filter(state == "Florida" & enddate >= "2016-11-04" ) %>% 
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100)

results <- polls %>% summarize(avg = mean(spread),  se = sd(spread)/sqrt(n()))
results

#           avg            se
# 1  0.004154545  0.007218692

###########################################

# Define `mu` and `tau`
mu <- 0
tau <- 0.01

# Define a variable called `sigma` that contains the standard error in the object `results
sigma <- results$se

# Define a variable called `Y` that contains the average in the object `results`
Y <- results$avg

# Define a variable `B` using `sigma` and `tau`. 
B <- sigma^2 / (sigma^2 + tau^2)
B # 0.342579

# expected value of the posterior distribution
exp_val <- B*mu + (1-B)*Y
exp_val # 0.002731286


# standard error of the posterior distribution.
se <- sqrt(1 / ((1/sigma^2)+(1/tau^2)))
se # 0.005853024

####################################

# Construct the 95% credible interval. 
# Save the lower and then the upper confidence interval to a variable called `ci`.

ci <- B*mu + (1-B)*Y + c(lower = -1, upper = 1) * qnorm(0.975) * sqrt( 1/ (1/sigma^2 + 1/tau^2))

ci 
#        lower         upper 
# -0.008740432   0.014203003 

####################################

# expected value of the posterior distribution
exp_value <- B*mu + (1-B)*Y 

# standard error of the posterior distribution
se <- sqrt( 1/ (1/sigma^2 + 1/tau^2))

# probability that the actual spread was less than 0 (in Trump's favor). 
# probability that Trump wins Florida
pnorm(0, exp_value, se) # 0.3203769

####################################

# Define a variable `taus` as different values of tau
taus <- seq(0.005, 0.05, len = 100)

# Create a function called `p_calc` that generates `B` and 
# calculates the probability of the spread being less than 0

p_calc <- function(tau){
  B <- sigma^2 / (sigma^2 + tau^2)
  pnorm(0, B*mu + (1-B)*Y, sqrt( 1/ (1/sigma^2 + 1/tau^2)))
}

# Create a vector called `ps` by applying the function `p_calc` across values in `taus`
ps <- p_calc(taus)

# Plot `taus` on the x-axis and `ps` on the y-axis
plot(taus, ps)

####################################
