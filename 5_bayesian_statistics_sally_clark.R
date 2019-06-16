# probability of the first son dying of SIDS
Pr_1 <- 1/8500

# probability of the second son dying of SIDS
Pr_2 <- 1/100

# probability of both sons dying of SIDS.
Pr_1 * Pr_2 # 1.176471e-06

#######################################

# probability of both sons dying of SIDS
Pr_B <- Pr_1*Pr_2

# rate of mothers that are murderers
Pr_A <- 1/1000000

# probability that two children die without evidence of harm, given that 
# their mother is a murderer
Pr_BA <- 0.50

# According to Bayes' rule
# probability that a mother is a murderer, given that 
# her two children died with no evidence of physical harm.
Pr_AB <- Pr_BA * Pr_A / Pr_B
Pr_AB # 0.425

#######################################

