pt(2,3) # 0.930337
pt(-2,3) # 0.06966298

# probability of seeing t-distributed random variables 
# being more than 2 in absolute value when 'df = 3'. 
1 - pt(2, 3) + pt(-2, 3) # 0.139326

#########################################

# Generate a vector 'df' that contains a sequence of numbers from 3 to 50
df <- seq(3,50)

# Make a function called 'pt_func' that calculates the probability 
# that a value is more than |2| for any degrees of freedom 
pt_func <- function(x) {1 - pt(2, x) + pt(-2, x)}

# Generate a vector 'probs' that uses the `pt_func` function to calculate the probabilities
probs <- sapply(df, pt_func)

# Plot 'df' on the x-axis and 'probs' on the y-axis
plot(df, probs)

#########################################
