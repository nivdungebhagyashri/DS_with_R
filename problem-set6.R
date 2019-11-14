---
title: 'IMT 573: Problem Set 6 - Inference and Monte Carlo'
author: "Bhagyashri Nivdunge"
date: 'Due: Tuesday, November 12, 2019'
output: pdf_document
---

<!-- This syntax can be used to add comments that are ignored during knitting process. -->

##### Collaborators: <!-- BE SURE TO LIST ALL COLLABORATORS HERE! -->
Hrishika Shetty

##### Instructions:

Before beginning this assignment, please ensure you have access to R and RStudio; this can be on your own personal computer or on the IMT 573 R Studio Server. 

1. Download the `problemset4.rmd` file from Canvas or save a copy to your local directory on RStudio Server. Open `problemset4.rmd` in RStudio and supply your solutions to the assignment by editing `problemset4.rmd`. 

2. Replace the "Insert Your Name Here" text in the `author:` field with your own full name. Any collaborators must be listed on the top of your assignment. 

3. Be sure to include well-documented (e.g. commented) code chucks, figures, and clearly written text chunk explanations as necessary. Any figures should be clearly labeled and appropriately referenced within the text. Be sure that each visualization adds value to your written explanation; avoid redundancy -- you do no need four different visualizations of the same pattern.

4.  Collaboration on problem sets is fun and useful, and we encourage it, but each student must turn in an individual write-up in their own words as well as code/work that is their own.  Regardless of whether you work with others, what you turn in must be your own work; this includes code and interpretation of results. The names of all collaborators must be listed on each assignment. Do not copy-and-paste from other students' responses or code.

5. All materials and resources that you use (with the exception of lecture slides) must be appropriately referenced within your assignment.  

6. Remember partial credit will be awarded for each question for which a serious attempt at finding an answer has been shown. Students are \emph{strongly} encouraged to attempt each question and to document their reasoning process even if they cannot find the correct answer. If you would like to include R code to show this process, but it does not run withouth errors you can do so with the `eval=FALSE` option.

```{r example chunk with a bug, eval=FALSE, include=FALSE}
a + b # these object dont' exist 
# if you run this on its own it with give an error
```

7. When you have completed the assignment and have **checked** that your code both runs in the Console and knits correctly when you click `Knit PDF`, rename the knitted PDF file to `ps4_ourLastName_YourFirstName.pdf`, and submit the PDF file on Canvas.

##### Setup

Load any R packages of interest here.

```{r Setup, message=FALSE}

```

**NOTE: You do not need to perform all calculations in R. Writing them in LaTeX and/or plain text is completely fine. However, be sure your work is readable and understandable. If you do solve problems programmatically, clearly describe your approach and what you are doing.**

#### Problem 1: Fathers and Sons

We will examine the heights of fathers and sons (\textit{fatherson.csv} from the previous problem set). If we look at sample means, we see that sons are taller than their fathers. But could this difference be due to chance?


##### (a) Load the data and examine it. \textit{fheight} are fathers' heights and \textit{sheight} are sons' heights. How many observations are there? Are there missing values?

```{r}

library(readr)
#load data
fatherson <- read_tsv("fatherson.csv.bz2")

#observe data
head(fatherson)
summary(fatherson)
nrow(fatherson)

#check for missing values in data
sum(is.na(fatherson$fheight))
sum(is.na(fatherson$sheight))

```
ans: there are 1078 rows in the data and there are no missing values

##### (b) What is an appropriate measurement type/scale for these variables? Are the values discrete or continuous?

ans: Height is measured as Ratio and it is continuous data

##### (c) Describe the fathers' and sons' heights. What do the descriptive statistics look like? Are there any unexpected values? In general, who tends to be taller: fathers or sons?

```{r}
#descriptive statistics for data
summary(fatherson)

```
from the above descriptive statisics, we dont see any unexpected values. In general Sons height has higher mean than fathers height, hence we can say sons are talled than fathers from the desciptive statistics.

Sons height has higher mean and median values than fathers heights. Also the maxium value of height is higher in sons' height

##### (d) Create a density plot with both sets of heights overlayed on the same figure. How do these plots look? What do they suggest in terms of fathers' and sons' relative heights?

```{r}
#plot the density plots
plot(density(fatherson$sheight), col="green", main="Father vs Son",xlab="Heights (cm)", ylab="Density")
lines(density(fatherson$fheight), col = "red")
legend("topright", legend=c("Son","Father"), fill=c("green","red"))
```
ans: from the plot it looks like sons height is relatively larger than Fathers heights and fathers height is spread over larger area than son's.

##### (e) Let's do a t-test to determine if the differences we observe are statistically significant. Compute the t-statistic yourself (i.e. do NOT use any pre-existing functions that perform the test). We want to perform what is called a two-sample t-test (we are not going to assume the fathers and sons are paired in some way) and we want to test whether there is a difference in the means.

```{r}
#compute means of father and son's height
fathermean <- mean(fatherson$fheight)
sonmean <- mean(fatherson$sheight)

#compute std deviations
fathersd <- sd(fatherson$fheight)
sonsd <-sd(fatherson$sheight)

#print std deviation
fathersd
sonsd

#pooled variance
pooled_var <- (((fathersd^2) * (nrow(fatherson)-1)) + ((sonsd^2) * (nrow(fatherson)-1)))/(nrow(fatherson)*2-2)
#std error  
SE <- sqrt((pooled_var/nrow(fatherson)) + (pooled_var/nrow(fatherson)))
SE
#t test stat
t_f_s <- (sonmean - fathermean)/SE
t_f_s

#difference between means
mean_diff = sonmean - fathermean
mean_diff

#fishers test for homogeniety of variance (HOV)
var.test(fatherson$fheight,fatherson$sheight)

```


##### (f) Did you use pooled or unpooled standard errors in your calculations? Why or why not? (Hint: see OpenIntro Stats 7.3.4)

ans: population variance is unknown in this case and the two situations of calculating standard error depends on the homogeniety of variance (HOV) assumption.

While the std deviations of both datasets are pretty close, and it also does not violet HOV, hence we should use pooled std deviations 

We have used pooled standard erros in the calculations, we see there is no significant difference between Standard Deviation or Fathers' height and Sons' height
     
##### (g) Using a t-table, what is the likelihood that the t-statistic you calculated occurs just by random chance? (Hint: be sure you have the appropriate degrees of freedom)

we have t-statistics value :  8.32387
and the degree of freedom is : 1078-1 = 1077
When we look at the t-table for the df greater than 1000, in the next row we see for aplha value =0.001 maximum value of t-statistics is 3.291.
and the t-statistics we have got is 8.32387 which is far greater than 3.291 hence alpha value will be far lower than 0.001, hence it is not likely to happen we get this t-statistics by rnadom chance. 

##### (h) What do you find when performing the t-test? Are the differences statistically significant? Interpret your results.

After the t-statistics and alpha value we can say, we can successfully reject the null hypothesis. Hence Sons' height is not significantly higher than Fathers' height and the differences are not statistically significant. 

#### Problem 2: A Monte Carlo Approach

Now, let's examine the same data but using a what's called a Monte Carlo approach. In essence, we're going to leverage repeated (re-)sampling of our data (something we'll discuss more in a few weeks when talking about bootstrapping).

##### (a) What is the overall mean and standard deviation for all heights? (i.e. when examining fathers' and sons' heights together)

```{r}

#create combined vector with both variables
fathgerandson <- c(fatherson$fheight,fatherson$sheight)

#mean of the combined data
combined_mean <- mean(fathgerandson)

#std deviation of the combined data
combined_sd <- sd(fathgerandson)


```


##### (b) Create two samples of data pulled from random normals. For both of these distributions, let the size of the sample equal that of the fathers' (or sons') heights. Let the mean and standard deviation be those that you calculated in 2-a. Note that you want two samples pulled from the same distribution - one of these we'll call "fathers" and the other we'll call "sons." What scenario are we simulating here with respect to the differences in fathers and sons heights? (Hint: think about a null hypothesis)

```{r}

#set see for creating sets
set.seed(198)

#create fathers set with mean and sd from above
fathers <- rnorm(1078,combined_mean,combined_sd)

#create sons set with mean and sd from above
sons <- rnorm(1078,combined_mean,combined_sd)


```
we can describe our null hypothesis as follows:

null hypothesis: sons' heights is greater than fathers' height
alternative hypothesis: sons' height is not greater than fathers' height

##### (c) What is the difference in means between the fathers' and sons' heights based using the simulated data? How does this compare to the difference in means for the dataset we read in?

```{r}
#mean of the sons height
mean_son <- mean(sons)

#mean of the fathers heights
mean_fathers <- mean(fathers)

#diff between the means
diff_mean <- mean_son-mean_fathers
diff_mean

```

ans:Here mean difference is -0.439 and it changes with seed but again the difference in the means in this case is very neglisible in compared to difference in the previous case. Hence we cannot really say sons' mean is always greater than fathers' mean

##### (d) Now, repeat problem 2-b a large number of times (S; with S > 1000). At each iteration, store the difference in means of the fathers' and sons' heights so you ultimately end up with S different values for the difference in means.

```{r}

#new vector to save all diffs
diff_vector <- c()

#repeat the step 1000 times using a loop and save values to above vector
for(i in 1:1000) {
    set.seed(i+10)
    set1 <- rnorm(1078,combined_mean,combined_sd)
    mean1 <- mean(set1)
    set2 <- rnorm(1078,combined_mean,combined_sd)
    mean2 <- mean(set2)
    diff <- mean1 - mean2 
    diff_vector <- c(diff_vector,diff)
}

```

##### (d) What is the mean of the differences? Explain why you see the result that you do.

```{r}
#mean of diffs
mean(diff_vector)

```
Here the differences of the mean is 0.0108, which very less than the mean of the differences we got for the actual data without simulations. This difference is neglisible in this case compared to actual difference we got above.

##### (e) What is the standard error of the differences? How do these compare to the values we saw with the non-simulated data when computing the t-statistic?

```{r}
#standard error of the differences
SE_diff <- sd(diff_vector)/sqrt(1000)
SE_diff
```
Standard error here is  0.01043109 and standard error we got while calculating t-test was 0.3041859, there is a large difference between the value of SE in this case and the SE value in non-simulated data. SE error in this case lower than the standard error in non-simulated data

##### (f) What is the largest difference we encounter (in terms of absolute value)? How does this compare to the difference in means that we saw with the non-simulated data?
```{r}

#taking absolute value of the vector
abs_diff_vector <- abs(diff_vector)
#finding the max value
max(abs_diff_vector)

```
Currently we have larget difference of the mean 1.05 and from the non-simulated data we have got 2.532004, the difference of mean we got here is not neglisible but it is significantly smaller than the diff of mean we have from the non-simulated data.

##### (g) What is the 5th and 95th percentile of differences?

```{r}

#5th quantile
quantile(abs_diff_vector, 0.05)

#95th quantile
quantile(abs_diff_vector, 0.95)

```
5th percentile - 0.01829302 
95th percentile - 0.638025 

##### (h) Now, increase S to increasingly large numbers and note the maximum difference in means that you see for each S. Do you see a maximum difference that is comparable to the actual difference in means that we encountered with the non-simulated data? If so, how often? Is this expected?

```{r}

#new vector
diff_vector_new <- c()

#where size is 20000
for(i in 1:20000) {
    set.seed(i)
    set1 <- rnorm(1078,combined_mean,combined_sd)
    mean1 <- mean(set1)
    set2 <- rnorm(1078,combined_mean,combined_sd)
    mean2 <- mean(set2)
    diff <- mean1 - mean2 
    diff_vector_new <- c(diff_vector_new,diff)
}

#finding the maxim value of absolute differences
abs_diff_vector_new <- abs(diff_vector_new)
max(abs_diff_vector_new)
```
Increased S to 20000 in the above simulation, for S of 1000 we got maximum differences in the mean as 1.051361 and in this case of S=20000 we got 1.260689. In both of these case maxium difference is less the actual difference between the mean in non-simulated data. I feel it is expected, as we are increasing the sample size we see less difference which is what our t-test suggest and that is why we rejected the null hypothesis, basically there should be less difference than the actaul differnece in the mean in non-simulated data.

