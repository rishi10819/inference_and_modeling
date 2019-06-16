library(dslabs)
library(tidyverse)

# Load the data
data("polls_us_election_2016")

nrow(polls_us_election_2016) # 4208

# Generate an object `polls` that contains 
# data filtered for polls that ended on or after October 31, 2016 in the United States
polls <- polls_us_election_2016 %>% filter(enddate >= "2016-10-31" & state == "U.S.") 

nrow(polls) # 70
view(polls)

# Assign the sample size of the first poll in `polls` to a variable called `N`.
N <- polls$samplesize[1]
N

# For the first poll in `polls`, convert the percentage to a proportion of Clinton voters
X_hat <- polls$rawpoll_clinton[1]/100
X_hat # 0.47

# Calculate the standard error of `X_hat`
se_hat <- sqrt(X_hat*(1-X_hat)/N)
se_hat # 0.01059279

# calculate the 95% confidence interval for the proportion of Clinton voters. 
# Save the lower and then the upper confidence interval to a variable called `ci`.
ci<- c(lower = X_hat - qnorm(0.975)*se_hat, upper = X_hat + qnorm(0.975)*se_hat)

ci

#      lower        upper 
# 0.4492385    0.4907615

##############################################

pollster_results <- polls %>%
  mutate(X_hat  = polls$rawpoll_clinton/100)        %>%
  mutate(se_hat = sqrt(X_hat*(1-X_hat)/samplesize)) %>%
  mutate(lower  = X_hat - qnorm(0.975)*se_hat)      %>%
  mutate(upper  = X_hat + qnorm(0.975)*se_hat)      %>%
  select(pollster, enddate, X_hat, se_hat, lower, upper)

# view(pollster_results)

##############################################

# Add a logical variable called `hit` that indicates 
# whether the actual value exists within the confidence interval of each poll. 
# Summarize the average `hit` result 
# to determine the proportion of polls with confidence intervals include the actual value. 

avg_hit <- pollster_results %>% 
  mutate(hit = lower<=0.482 & upper>=0.482) %>% 
  summarize(mean(hit))

avg_hit

#     mean(hit)
# 1   0.3142857

##############################################

# d_hat column contains the difference in the proportion of voters.
polls <- polls_us_election_2016 %>% filter(enddate >= "2016-10-31" & state == "U.S.")  %>%
  mutate(d_hat = rawpoll_clinton/100 - rawpoll_trump/100)

# Assign the sample size of the first poll in `polls` to a variable called `N`. 
N <- polls$samplesize[1]

# For the difference `d_hat` of the first poll in `polls` to a variable called `d_hat`.
d_hat <- polls$d_hat[1]
d_hat # 0.04

# Assign proportion of votes for Clinton to the variable `X_hat`.
X_hat <- (d_hat+1)/2
X_hat # 0.52

# Calculate the standard error of the spread
se_hat <- 2*sqrt(X_hat*(1-X_hat)/N)
se_hat # 0.02120683

# calculate the 95% confidence interval for the difference in the proportions of voters. 
# Save the lower and then the upper confidence interval to a variable called `ci`.
ci <- c(lower = d_hat - qnorm(0.975)*se_hat, upper = d_hat + qnorm(0.975)*se_hat)

##############################################

# Create a new object called `pollster_results_2` that contains columns for 
# pollster name, end date, d_hat, lower confidence interval of d_hat, and 
# upper confidence interval of d_hat for each poll.

pollster_results_2 <-  polls %>% 
  mutate(X_hat = (d_hat+1)/2, 
         se_hat = 2*sqrt(X_hat*(1-X_hat)/samplesize), 
         lower = d_hat - qnorm(0.975)*se_hat, 
         upper = d_hat + qnorm(0.975)*se_hat) %>% 
  select(pollster, enddate, d_hat, lower, upper)

# view(pollster_results_2)

##############################################

# Add a logical variable called `hit` that 
# indicates whether the actual value (0.021) exists within the confidence interval of each poll. 
# Summarize the average `hit` result 
# to determine the proportion of polls with confidence intervals include the actual value. 

avg_hit <- pollster_results_2 %>% 
  mutate(hit = lower<=0.021 & upper>=0.021) %>% 
  summarize(mean(hit))

avg_hit

#     mean(hit)
# 1   0.7714286

##############################################

# Add variable called `error` to the object `polls` that 
# contains the difference between d_hat and the actual difference on election day. 
# Then make a plot of the error stratified by pollster.

polls %>% mutate(error = d_hat - 0.021) %>% 
  ggplot(aes(x = error, y = d_hat)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

##############################################

# Add variable called `error` to the object `polls` that 
# contains the difference between d_hat and the actual difference on election day. 
# Then make a plot of the error stratified by pollster, but 
# only for pollsters who took 5 or more polls.

polls %>% mutate(error = d_hat - 0.021) %>%
  group_by(pollster) %>%
  filter(n() >= 5) %>%
  ggplot(aes(pollster, error)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

##############################################
