---
title: 'IMT 573: Problem Set 5 - Bayes Theorem & Distributions'
author: "Bhagyashri Nivdunge"
date: 'Due: Tuesday, November 5, 2019'
output: pdf_document
---

<!-- This syntax can be used to add comments that are ignored during knitting process. -->

##### Collaborators: <!-- BE SURE TO LIST ALL COLLABORATORS HERE! -->

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
library('dplyr')
```

**NOTE: You do not need to perform all calculations in R. Writing them in LaTeX and/or plain text is completely fine. However, be sure your work is readable and understandable. If you do solve problems programmatically, clearly describe your approach and what you are doing.**

#### Problem 1: Overbooking Flights

You are hired by Air Nowhere to recommend the optimal overbooking rate. It is a small airline that uses a 100-seat plane to carry you from Seattle to, well, nowhere. The tickets cost $100 each. The sales team has found that the probability, that the passengers who have paid their fare actually show up is 98%, and individuals showing up can be considered independent. The additional costs, associated with finding an alternative solutions for passengers who are refused boarding are \$500 per person.


##### (a) Which distribution would you use to characterize the actual number of people who show up for flights?
ans: Binomial Distribution

##### (b) Assume the airline never overbooks. What is the expected revenue from a full flight in this scenario? Expected revenue is the expected income from ticket sales minus expected costs related to alternative solutions.
ans: (100*100)-(0) -> 10000
```{r}
revenue <- 100*100
revenue
```


##### (c) Now assume the airline sells 101 tickets for 100 seats on a given flight. What is the probability that all 101 passengers will show up?
ans: 0.98 ** 101 = 0.1299672
(0.98 raised to power 101)

```{r}
show_101 <- 0.98 ** 101
show_101
```
```{r}
dbinom(101,101,0.98)
```

##### (d) What are the expected profits (where profits are revenue - expected additional costs) when the airlines sells 101 tickets for 100 seats? Would you recommend overbooking or selling just the right number of tickets per flight?
ans: 
case 1: overbooked
expected profit = (100*101) - ((0.98 ** 101)*500) => 
case 2: no overbooking
expected profit = (100*100) => 10000

```{r}
profit <- (100*101) - ((0.98 ** 101)*500)
profit

```


##### (e) Now assume the airline sells 102 tickets for 100 seats on a given flight. What is the probability that all 102 passengers show up?
ans: 0.98 **102 
```{r}
show_102 <- 0.98 **102 
show_102
```
```{r}
dbinom(102,102, 0.98)
```


##### (f) What is the probability that 101 passengers - still one too many - will show up when 102 tickets are sold for a given flight?
ans: 
P(102,1) -> 102
probabilty = 102* (0.98 ** 101) * (0.02 *1) (conditional probability)

```{r}
probability <- 102* (0.98 ** 101) * (0.02 *1)

probability
```

```{r}
dbinom(101,102, 0.98)
```


##### (g) Would it be advisable to sell 102 tickets, 101 tickets, or 100 tickets for a given flight if the airline wanted to maximize revenue? (i.e. which has the highest expected revenue: selling 100, 101, or 102 tickets? 
ans:  
We will just calculate revenue and not profit
selling 102 tickets , revenue = 102*100 = 10200
selling 101 tickets , revenue = 101*100 = 10100
selling 100 tickets , revenue = 100*100 = 10000
selling 102 tickets has max revuenu

##### (h) What is the optimal number of seats to sell for the airline? How much are expected profits the expected profits in this case?


```{r}
profit_noovrBooked <- (100*100)-0
profit_noovrBooked

profit_when_101 <- (100*101) - ((0.98 ** 101)*500)
profit_when_101 

profit_when_102_show101 <- (100*102) - (0.265133*500)
profit_when_102_show101

profit_when_102_show102 <- (100*102) - (0.1273678*500*2)
profit_when_102_show102


```
Optimal number of seats should be 102


##### (g) What does it mean to state that individuals showing up for a flight are independent? Why is this important in this case?
ans: probability of one person missing the flight will not change the probability of other person missing the flight, the probability is same of every person irrespective of other person showing or missing. 
This is important for calculations because we have not considered probability as a function of number of poeple not showing up.

#### Problem 2: Asking Data Science Questions: Crime and Educational Attainment

For a given exam, there is a multiple-choice question with four (mutually exclusive) options. On average, 80% of the students know the answer. Among those who know the answer, 10% answer incorrectly due to exam stress.

##### (a) If a student gets the answer correct, what is the probability that they actually know the material?

Be sure to describe and outline each step in your calculations.
ans: 
Let A be the event where student knows the correct answer
Let B be the event that student answered correctly

Using Baye's Theorem
P(A|B) = P(B|A).P(A)/(P(B|A)P(A) + P(B|A')P(A'))

P(B|A) = 0.9 (Probaility that student answered correctly given he knows the answer)
P(A) = 0.8 (Probability that student knows the answer)
P(B|A`) = 0.25 (Probability that student answered correctly but didn't know the answer so guessing probability = 1/4)
P(A`) = 0.2 (Probability that student does not know the answer)

P(A|B) = 0.72 /(0.72 + 0.05) = 0.72/0.77 = 0.935

#### Problem 3: Histograms and distributions

In this problem, you will be examining human height and citation counts for research papers (separately).

##### (a) What kind of measure is human height (nominal, ordinal, interval, ratio)? How should it it be measured (continuous, discrete; positive, negative, either)?
ans: human height is ratio scale, so it measured as continuous 

##### (b) Read in the "fatherson.csv" data. The data consists of two columns: father's height and son's height (both in cm). Let's focus on fathers' heights (\textit{fheight}). How many observations are there? Are there any missing values?
```{r}
#read file
fatherson <- read.csv(file="fatherson.csv")
#create dataframe
fathersondf<- tbl_df(fatherson)

head(fathersondf,10)
 #convert factor to char
fathersondf$fheight.sheight <- as.character(fathersondf$fheight.sheight)

#create two columns from one
new_df <- data.frame(do.call('rbind', strsplit(as.character(fathersondf$fheight.sheight),'\t',fixed=TRUE)))

#change column names
names(new_df)[1]<-"fheight"
names(new_df)[2]<-"sheight"


#convert columns to numeric
new_df$fheight <- as.numeric(as.character(new_df$fheight))
new_df$sheight <- as.numeric(as.character(new_df$sheight))


#count observations
nrow(new_df)

#count missing values
sum(is.na(new_df$fheight))


```

Ans: there are 1078 observations and there are no missing values.

##### (c) Compute the mean, median, standard deviation, and range of the heights. Discuss the relationship between these numbers. Is the mean larger than the median? What does this suggest? Would calculating the mode give a useful descriptive statistic? Why or why not? How does standard deviation compare to mean?
```{r}

# computation for fathers height
mean <- mean(new_df$fheight)
mean

median <-  median(new_df$fheight)
median

sd <- sqrt(var(new_df$fheight))
sd



range <- range(new_df$fheight)
range

# computation for sons height
n_mean <- mean(new_df$sheight)
n_mean

n_median <-  median(new_df$sheight)
n_median

n_sd <- sqrt(var(new_df$sheight))
n_sd

n_range <- range(new_df$sheight)
n_range


#calculating mode

mode <- function(x) {
      ux <- unique(x)
      ux[which.max(tabulate(match(x, ux)))]
}

f_mode <- mode(new_df$fheight)
f_mode

s_mode <- mode(new_df$sheight)
s_mode

summary(new_df)
 
```
ans: 
In above observations Mean is slightly larger than Median. This tells us the distribution is right skewed. 
Mode does not give any reliable descriptive statistics, becase data is continuous data and its not categorical data where mode will be useful. The chances of perticular height having max frequency are very low.
We have standard deviation 6.972346 for fathers' height hence maximum values lie in 171.9252+-6.972346


##### (d) Plot a histogram of the data. On the same plot, overlay a plot of the normal distribution with the same mean and standard deviation as the data. Additionally, indicate the mean and median of the data using vertical lines of different colors. What do you find? Are the histogram and the density plot similar?
```{r}
#histogram of fathers height
hist(new_df$fheight,
main="Histogram of fathers height",
xlab="height",
col="darkmagenta",
freq=FALSE
)
curve(dnorm(x, mean=mean, sd=n_sd), 
      col="darkblue", lwd=2, add=TRUE, yaxt="n")
#draw mean with yellow line
abline(v=mean, col="yellow")
#draw median with green line
abline(v=median, col="green")


#histogram of sons height
hist(new_df$sheight,
main="Histogram of sons height",
xlab="height",
col="darkmagenta",
freq=FALSE
)
curve(dnorm(x, mean=n_mean, sd=n_sd), 
      col="darkblue", lwd=2, add=TRUE, yaxt="n")
#draw mean with yellow line
abline(v=n_mean, col="yellow")
#draw median with green line
abline(v=n_median, col="green")


```
Ans: 
for fathers height histogram and density plots are almost similar but sons height we can see a difference between histogram and sons height.
Mean and median lines matches with density plot more the histogram, density plot gives more close presentation on mean and median in this data.


##### (e) Read in the "mag-in-citations.csv" data. This is Microsoft Academic's Graph for citations of research papers and it contains two columns: paper id and the number of citations. We will only look at the number of citations. How many observations are there? Are there any missing values?

```{r}
#read file
citation <- read.csv(file="mag-in-citations.csv")

#create dataframe
citation_df<- tbl_df(citation)
nrow(citation_df)

sum(is.na(citation_df$citations))


```
Ans:
Number of observations 388258
There are 0 missing values


##### (f) What kind of measure is the citation counts for research papers (i.e. the number of times that a paper is referenced by other papers)? How should it be measured?

ans: Citation is a ratio variable which can has 0 but no negative values. It will be measured as discrete data.



##### (g) Compute the mean, median, standard deviation, and range of the citations. Discuss the relationship between these numbers. Is the mean larger than the median? What does this suggest? Would calculating the mode give a useful descriptive statistic? Why or why not? How does standard deviation compare to mean?

ans: 
```{r}
# computation for fathers height
cmean <- mean(citation_df$citations)
cmean

cmedian <-  median(citation_df$citations)
cmedian

csd <- sqrt(var(citation_df$citations))
csd

crange <- range(citation_df$citations)
crange

```

##### (h) Calculate the 90th percentile for the citation data. How does this compare to the maximum value of the citation data? Calcualte the 10th percentile for the citation data. How does this compare to the minimum value of the citation data? What does this all suggest with respect to the shape of the distribution of citation counts?

```{r}
# 90th percentile for the citation data
quantile(citation_df$citations, 0.90)

# 10th percentile for the citation data
quantile(citation_df$citations, 0.10)

#minimum data
min(citation_df$citations)





```
This data suggest, 

##### (i) Plot a histogram of the data. On the same plot, overlay a plot of the normal distribution with the same mean and standard deviation as the data. Additionally, indicate the mean and median of the data using vertical lines of different colors. What do you find? Are the histogram and the density plot similar? Now try this with what is called a "log-log" transformation (i.e. plotting the x and y axes on a logarithmic scale)

```{r}
#without log-log transformation

#convert to numeric
citation_df$citations<-as.numeric((citation_df$citations))

#plot citation

hist(citation_df$citations,
     main="Histogram for Sons' heights",
     xlab="Sons' height",
     col='blue',
     freq = FALSE)
curve(dnorm(x, mean=cmean,sd=csd),col="darkblue",lwd=2, add=TRUE, yaxt="n")
abline(v=cmean, col='yellow')
abline(v=csd, col='green')

```
```{r}
# with log transformation

#convert to numeric
citation_df$citations<-as.numeric((citation_df$citations))

#plot citation
with_log <- log10(citation_df$citations)
hist(with_log ,
     main="Histogram for Sons' heights",
     xlab="Sons' height",
     col='yellow',
     freq = FALSE)
curve(dnorm(x, mean=cmean,sd=csd),col="darkblue",lwd=2, add=TRUE, yaxt="n")
abline(v=cmean, col='blue')
abline(v=csd, col='green')
```



##### (j) Seeing how well (or not well) that the heights and the citations datasets align with the normal distribution, what are your thoughts on these datasets and do the findings make sense with respect to what we'd expect to see concerning heights and influence (as measured by citations)?
ans: after log transformation we see the distribution is right skewed, this matches with observation we had, where mean was greater than median. In the previous dataset we had values continuous and these values are discrete.
Findings make sense with what we would expect, we see maxium height has low frequency whic was expected.

