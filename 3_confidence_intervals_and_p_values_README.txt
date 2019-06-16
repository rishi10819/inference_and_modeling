Here we will use actual poll data from the 2016 election. 
"polls_us_election_2016" data from dslabs package.
We will use all the national polls that ended within a few weeks before the election.
Assume there are only two candidates and construct a 95% confidence interval for the election night proportion p.
Include polls that ended on or after October 31, 2016 (enddate). 
Only include polls that took place in the United States. 
Convert the percentage of Clinton voters (rawpoll_clinton) from the first poll in polls to a proportion, X_hat. 
Find the standard error of X_hat given N. 
Calculate the 95% confidence interval of this estimate.
Save the lower and upper confidence intervals as an object called ci. 

-------------------------------

Create a new object called pollster_results that contains 
the pollster's name, 
the end date of the poll, 
the proportion of voters who declared a vote for Clinton, 
the standard error of this estimate, and 
the lower and upper bounds of the confidence interval for the estimate.

-------------------------------

The final tally for the popular vote was Clinton 48.2% and Trump 46.1%. 
Add a column called hit to pollster_results that states if the confidence interval included the true proportion p=0.482 or not. 
What proportion of confidence intervals included p ?

-------------------------------

A much smaller proportion of the polls than expected produce confidence intervals containing p. 
Notice that most polls that fail to include p are underestimating. 
The rationale for this is that undecided voters historically divide evenly between the two main candidates on election day.

In this case, it is more informative to estimate the spread or 
the difference between the proportion of two candidates d, or 
0.482 - 0.461 = 0.021, 
for this election.

Assume that there are only two parties and that d = 2p-1. 
Construct a 95% confidence interval for difference in proportions on election night.

-------------------------------

Create a new object called pollster_results_2 that contains 
the pollster's name, 
the end date of the poll, 
the difference in the proportion of voters who declared a vote either, 
the standard error of this estimate, and 
the lower and upper bounds of the confidence interval for the estimate.

-------------------------------

What proportion of confidence intervals for the difference between the proportion of voters included d, the actual difference in election day?

-------------------------------

Calculate the difference between each poll's estimate d-bar and the actual d = 0.021. 
Stratify this difference, or error, by pollster in a plot.

-------------------------------

Remake the plot, but only for pollsters that took five or more polls. 

-------------------------------





