Confidence Intervals of Polling Data.
For each poll in the polling data set, use the CLT to create a 95% confidence interval for the spread. 
Create a new table called cis that contains columns for the lower and upper limits of the confidence intervals.

------------------------------

Compare to Actual Results.
Add the final result to the table you just created.
Now determine how often the 95% confidence interval includes the actual result.

------------------------------

Stratify by Pollster and Grade.
Now find the proportion of hits for each pollster. 
Show only pollsters with more than 5 polls and order them from best to worst. 
Show the number of polls conducted by each pollster and the grade of each pollster.

------------------------------

Stratify by State.
Now find the proportion of hits for each state.
Show only states with more than 5 polls and order them from best to worst. 
Show the number of polls conducted in each state.

------------------------------

Plotting Prediction Results.
Make a barplot based on the result from the previous results.

Reorder the states in order of the proportion of hits.
Set the aesthetic with state as the x-variable and proportion of hits as the y-variable.
Height of the bar should match the value.
States should be displayed from top to bottom and proportions should be displayed from left to right.

------------------------------

Predicting the Winner.
Even if a forecaster's confidence interval is incorrect, the overall predictions will do better if they correctly called the right winner. 
Add two columns to the cis table by computing, for each poll, the difference between the predicted spread and the actual spread, 
and define a column hit that is true if the signs are the same.

------------------------------

Plotting Prediction Results.

Create an object called p_hits that contains the proportion of instances 
when the sign of the actual spread matches the predicted spread for states with more than 5 polls.

Make a barplot based on the result from the previous results that shows the 
proportion of times the sign of the spread matched the actual result for the data in p_hits.

------------------------------

Make a histogram of the errors. 
What is the median of these errors?

------------------------------

Plot Bias by State.
Create a boxplot to examine if the bias was general to all states or if it affected some states differently. 
Filter the data to include only pollsters with grades B+ or higher.

------------------------------

Filter Error Plot
Some of these states only have a few polls. 
Repeat the previous exercise to plot the errors for each state, but only include states with five good polls or more.