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
