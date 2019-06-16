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

p_hits

#       proportion_hits
# 1             0.66133

#######################################

# summarizes the proportion of hits for each pollster that has more than 5 polls. 
p_hits <- cis %>% 
  mutate(hit = lower <= actual_spread & upper >= actual_spread) %>% 
  group_by(pollster) %>%
  filter(n() >=  5) %>%
  summarize(proportion_hits = mean(hit), n = n(), grade = grade[1]) %>%
  arrange(desc(proportion_hits))

p_hits

#######################################

# summarizes the proportion of hits for each state that has more than 5 polls. 
p_hits <- cis %>% 
  mutate(hit = lower <= actual_spread & upper >= actual_spread) %>% 
  group_by(state) %>%
  filter(n() >=  5) %>%
  summarize(proportion_hits = mean(hit), n = n()) %>%
  arrange(desc(proportion_hits)) 

p_hits

#######################################

library (ggplot2)

# Make a barplot of the proportion of hits for each state
p_hits %>% mutate(state = reorder(state, proportion_hits)) %>%
  ggplot(aes(x = state, y = proportion_hits)) + 
  geom_bar(stat = "identity") +
  coord_flip()

#######################################

# calculates the difference between the predicted and actual spread and 
# indicates if the correct winner was predicted
errors <- cis %>% 
  mutate(error = spread - actual_spread, hit = sign(spread) == sign(actual_spread))

# Examine the last 6 rows of `errors`
tail(errors)

#######################################

# summarizes the proportion of hits for each state that has more than 5 polls
p_hits <- errors %>%  
  group_by(state) %>%
  filter(n() >=  5) %>%
  summarize(proportion_hits = mean(hit), n = n())

# Make a barplot of the proportion of hits for each state

# Here, we see that most states' polls predicted the correct winner 100% of the time. 
# Only a few states polls' were incorrect more than 25% of the time. 
# Wisconsin got every single poll wrong. 
# In Pennsylvania and Michigan, more than 90% of the polls had the signs wrong. 

p_hits %>% mutate(state = reorder(state, proportion_hits)) %>%
  ggplot(aes(state, proportion_hits)) + 
  geom_bar(stat = "identity") +
  coord_flip()

#######################################

# Generate a histogram of the error
hist(errors$error)

# Calculate the median of the errors.
# Here we see that, at the state level, the median error was slightly in favor of Clinton. 
# The distribution is not centered at 0, but at 0.037. 

median(errors$error) # 0.037

#######################################

# Create a boxplot showing the errors by state for polls with grades B+ or higher

errors %>% filter(grade %in% c("A+","A","A-","B+") | is.na(grade)) %>%
  mutate(state = reorder(state, error)) %>%
  ggplot(aes(state, error)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_boxplot() + 
  geom_point()

#######################################

# Create a boxplot showing 
# the errors by state for states with at least 5 polls with grades B+ or higher

# Here we see that the West (Washington, New Mexico, California) 
# underestimated Hillary's performance, while 
# the Midwest (Michigan, Pennsylvania, Wisconsin, Ohio, Missouri) overestimated it. 

errors %>% filter(grade %in% c("A+","A","A-","B+") | is.na(grade)) %>%
  
  group_by(state) %>%
  filter(n() >= 5) %>%
  ungroup() %>%
  
  mutate(state = reorder(state, error)) %>%
  ggplot(aes(state, error)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_boxplot() + 
  geom_point()

#######################################