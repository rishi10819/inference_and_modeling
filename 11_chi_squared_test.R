library(dplyr)
library(dslabs)

data("polls_us_election_2016")

# Create a table called `polls` that filters by  state, date, and reports the spread
polls <- polls_us_election_2016 %>% 
  filter(state != "U.S." & enddate >= "2016-10-31") %>% 
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100)

# estimate of the proportion of Clinton voters for each poll
X_hat <- (polls$spread+1)/2

# standard error of the spread
se <- 2*sqrt(X_hat*(1-X_hat)/polls$samplesize)

lower <- polls$spread - qnorm(0.975)*se
upper <- polls$spread + qnorm(0.975)*se

# Create an object called `cis` that contains columns for the lower and upper confidence intervals.
cis <- polls %>% 
  mutate(X_hat, se, lower, upper) %>%
  select(state, startdate, enddate, pollster, grade, spread, lower, upper)

#######################################

# actual results
add <- results_us_election_2016 %>% 
  mutate(actual_spread = clinton/100 - trump/100) %>% 
  select(state, actual_spread)

# Add the actual results to the `cis` data set
cis <- cis %>% 
  mutate(state = as.character(state)) %>% 
  left_join(add, by = "state")

# summarizes the proportion of confidence intervals that contain the actual value.
p_hits <- cis %>% 
  mutate(hit = lower <= actual_spread & upper >= actual_spread) %>% 
  summarize(proportion_hits = mean(hit))

#######################################

# summarizes the proportion of hits for each pollster that has more than 5 polls. 
p_hits <- cis %>% 
  mutate(hit = lower <= actual_spread & upper >= actual_spread) %>% 
  group_by(pollster) %>%
  filter(n() >=  5) %>%
  summarize(proportion_hits = mean(hit), n = n(), grade = grade[1]) %>%
  arrange(desc(proportion_hits))

#######################################

# summarizes the proportion of hits for each state that has more than 5 polls. 
p_hits <- cis %>% 
  mutate(hit = lower <= actual_spread & upper >= actual_spread) %>% 
  group_by(state) %>%
  filter(n() >=  5) %>%
  summarize(proportion_hits = mean(hit), n = n()) %>%
  arrange(desc(proportion_hits)) 

#######################################

library (ggplot2)

#######################################

# calculates the difference between the predicted and actual spread and 
# indicates if the correct winner was predicted
errors <- cis %>% 
  mutate(error = spread - actual_spread, hit = sign(spread) == sign(actual_spread))

##########################################

library(tidyr)

# Generate an object called 'totals' that contains the 
# numbers of good and bad predictions for polls rated A- and C-

totals <- errors %>%
  filter(grade %in% c("A-", "C-")) %>%
  group_by(grade,hit) %>%
  summarize(num = n()) %>%
  spread(grade, num)

# proportion of hits for grade C- polls
# C- polls predicted the correct winner about 80% of the time in their states
totals[[2,3]]/sum(totals[[3]]) # 0.8030303


# proportion of hits for grade A- polls
# A- polls predicted the correct winner about 86% of the time in their states
totals[[2,2]]/sum(totals[[2]]) # 0.8614958

##########################################

# The 'totals' data have already been loaded. Examine them using the `head` function.
head(totals)

# Perform a chi-squared test on the hit data. Save the results as an object called 'chisq_test'.
# X-squared = 2.1053, df = 1, p-value = 0.1468
chisq_test <- totals %>% 
  select(-hit) %>%
  chisq.test()
chisq_test

chisq_test$p.value # # 0.1467902

##########################################

# Generate a variable called `odds_C` 
# that contains the odds of getting the prediction right for grade C- polls

odds_C <- (totals[[2,2]] / sum(totals[[2]])) / 
  (totals[[1,2]] / sum(totals[[2]]))

# Generate a variable called `odds_A` 
# that contains the odds of getting the prediction right for grade A- polls

odds_A <- (totals[[2,3]] / sum(totals[[3]])) / 
  (totals[[1,3]] / sum(totals[[3]]))

# Calculate the odds ratio to determine 
# how many times larger the odds ratio is for grade A- polls than grade C- polls

odds_A/odds_C # 0.6554539

##########################################
