library(tidyverse)
library(dslabs)
data(heights)

# Make a vector of heights from all males in the population
x <- heights %>% filter(sex == "Male") %>%
  .$height

# Calculate the population average.
mu <- mean(x) 
mu # 69.31475

# Calculate the population standard deviation. 
sigma <- sd(x) 
sigma # 3.611024

####################################

# make sure your answer matches the expected result after random sampling
set.seed(1)

N <- 50 # number of people measured

# Define `X` as a random sample from our population `x`
X <- sample(x, size = N, replace = TRUE, prob = NULL)
#X

# Calculate the sample average.
mean(X) # 68.73423

# Calculate the sample standard deviation.
sd(X) # 3.761344

####################################

# make sure your answer matches the expected result after random sampling
set.seed(1)

# Define `X` as a random sample from our population `x`
X <- sample(x, N, replace = TRUE)

# standard error of the estimate.
se <- sd(X)/sqrt(N)
se # 0.5319343

# Construct a 95% confidence interval for the population average based on our sample. 
ci <- c(lower = mean(X) - qnorm(0.975)*se, upper = mean(X) + qnorm(0.975)*se)
ci

#    lower      upper 
# 67.69166   69.77681

####################################

mu <- mean(x) # population average

# make sure your answer matches the expected result after random sampling
set.seed(1)

N <- 50 # number of people measured
B <- 10000 # number of times to run the model

# Define an object `res` that contains a logical vector for simulated intervals that contain mu
res <- replicate(B, {
  X <- sample(x, N, replace=TRUE)
  interval <- mean(X) + c(-1,1)*qnorm(0.975)*sd(X)/sqrt(N)
  between(mu, interval[1], interval[2])
})

# proportion of results that include mu.
mean(res) # 0.9433

####################################

library(ggplot2)
#data("polls_us_election_2016")

# These lines of code filter for the polls we want and calculate the spreads
polls <- polls_us_election_2016 %>% 
  filter(pollster %in% c("Rasmussen Reports/Pulse Opinion Research","The Times-Picayune/Lucid") &
           enddate >= "2016-10-15" &
           state == "U.S.") %>% 
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100) 


# Make a boxplot with points of the spread for each pollster

polls %>% ggplot(aes(x = pollster, y = spread)) +
  geom_boxplot() +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

####################################

# Create an object called `res` that summarizes the average, standard deviation, and number of polls for the two pollsters.
res <- polls %>% group_by(pollster) %>% 
  summarize(avg = mean(spread), s = sd(spread), N = n()) 

# Store the difference between the larger average and the smaller in a variable called `estimate`. 
estimate <- res$avg[2] - res$avg[1]
estimate # 0.05229167

# Store the standard error of the estimates as a variable called `se_hat`.
se_hat <- sqrt ( res$s[2]^2/res$N[2] + res$s[1]^2/res$N[1] )
se_hat # 0.007031433

# Calculate the 95% confidence interval of the spreads. 
# Save the lower and then the upper confidence interval to a variable called `ci`.
ci <- c ( lower = estimate - qnorm(0.975)*se_hat, upper = estimate + qnorm(0.975)*se_hat )

ci
#      lower        upper 
# 0.03851031   0.06607302


# Calculate the p-value
2*(1 - pnorm(estimate/se_hat, 0, 1))

####################################

# filter the polling data and calculate the spread
polls <- polls_us_election_2016 %>% 
  filter(enddate >= "2016-10-15" &
           state == "U.S.") %>%
  group_by(pollster) %>%
  filter(n() >= 5) %>% 
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100) %>%
  ungroup()

# Create an object called `var` that contains columns for the 
# pollster, mean spread, and standard deviation.

var <- polls %>% group_by(pollster) %>%
  summarize(avg = mean(spread), std_deviation = sd(spread))

view(var)

####################################
