---
title: 'IMT 573: Problem Set 4 - Data Analysis'
author: "Bhagyashri Nivdunge"
date: 'Due: Tuesday, October 29, 2019'
output: pdf_document
---

<!-- This syntax can be used to add comments that are ignored during knitting process. -->

##### Collaborators: <!-- BE SURE TO LIST ALL COLLABORATORS HERE! -->

http://bkenkel.com/pdaps/visualization.html
https://www.rdocumentation.org/packages/ggpubr/versions/0.2.3/topics/ggboxplot
https://cran.r-project.org/web/packages/moonBook/moonBook.pdf
http://mrchengwms.weebly.com/uploads/5/8/5/6/58566549/study_guide__part_a__with_answers.pdf


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

In this problem set you will need, at minimum, the following R packages.

```{r Setup, message=FALSE}
# Load standard libraries
library(tidyverse)
library(gridExtra)
```

#### Problem 1: 50 States in the USA

In this problem we will use the `state` dataset, available as part of the R statistical computing platforms. This data is related to the 50 states of the United States of America. Load the data and use it to answer the following questions. 

##### (a) Describe the data and each variable it contains. Tidy the data, preparing it for a data analysis.

```{r}

#different vectors of state dataset
class(state.x77)
class(state.abb)
class(state.region)


#lets create one states data by adding these matrices as columns and convert this matrix to dataframe to do further investigation


states<- state.x77 %>%
  as_tibble() %>%
  add_column(State = rownames(state.x77),
             Abbrev = state.abb,
             Region = state.region,
             .before = 1) %>%
  rename(LifeExp = `Life Exp`,
         HSGrad = `HS Grad`)

#to dataframe
state_data <- tbl_df(states)

#summary of the dataset
head(state_data)
tail(state_data)
names(state_data)
str(state_data)
summary(state_data)

#data cleaning

row.has.na <- apply(state_data, 1, function(x){any(is.na(x))})
row.has.na

#lets check how many rows has NA
sum(row.has.na)

#there are no rows with NA

# let's convert region from Factor to Char

state_data$Region<-as.character(state_data$Region)
class(state_data$Region)

#lets add one more column population density for each state
state_data$Density <- state_data$Population * 1000 / state_data$Area    
```
Ans: Description of the data

State     : chr  (name of the states)
Abbrev    : chr  (Abbreviations of the states)
Region    : Factor (region out of four US regions)
Population: num  (population of the state)
Income    : num  (per capita income)
Illiteracy: num  (illiteracy (1970, percent of population))
LifeExp   : num  (life expectancy in years (1969–71))
Murder    : num  (murder and non-negligent manslaughter rate per 100,000 population )
HSGrad    : num  (percent high-school graduates)
Frost     : num  (mean number of days with minimum temperature below freezing (1931–1960) in capital or large city)
Area      : num  (land area in square miles)




##### (b) Suppose you want to explore the relationship between a state's `Murder` rate and other characteristics of the state, for example population, illiteracy rate, and more. Begin by examining the bivariate relationships present in the data. Present and interpret numeric value to describe the linear relationships as well as plots to contextualize these numeric values. What does your analysis suggest might be important varibles to consider in building a model to explain variation in murder rates? Are linear relationships appropriate to assume for all bivariate relationships? Why or why not?


```{r}

library(psych)
#summary

#this gives summary of numbers (mean,median, sd, min, max) for all the numerical columns, to iterpret numeric values
describe(state_data)[, c(1:5, 7:9)]

#lets extract only numeric values
state_numeric <- as.data.frame(state.x77)
state_numeric$Density <- state_numeric$Population * 1000 / state_numeric$Area  


#lets look at relationship among ll the variables
plot(state_numeric)

#plotting population vs murder rate
plot(state_data$Population,state_data$Murder, main="Murder vs Population Scatterplot",
   xlab="Population ", ylab="Murder rate", pch=19 ,xlim=c(365,21198))


# Draw a regression line
abline(reg = lm(state_data$Murder ~ state_data$Population), col = "red", lwd = 2)


#plotting illiteracy vs murder rate
plot(state_data$Illiteracy,state_data$Murder, main="Murder vs Illitercy Scatterplot",
   xlab="Illiteracy", ylab="Murder rate", pch=19)

abline(reg = lm(state_data$Murder ~ state_data$Illiteracy), col = "red", lwd = 2)


#plotting HSGrad vs murder rate
plot(state_data$HSGrad,state_data$Murder, main="Murder vs HSGrad Scatterplot",
   xlab="HSGrad ", ylab="Murder rate", pch=19)

abline(reg = lm(state_data$Murder ~ state_data$HSGrad), col = "red", lwd = 2)

#plotting HSGrad vs murder rate
plot(state_data$LifeExp,state_data$Murder, main="Murder vs Life Expectancy Scatterplot",
   xlab="Life Expectancy ", ylab="Murder rate", pch=19)

abline(reg = lm(state_data$Murder ~ state_data$LifeExp), col = "red", lwd = 2)


#plotting HSGrad vs murder rate
plot(state_data$Frost,state_data$Murder, main="Murder vs Frost Scatterplot",
   xlab="Frost", ylab="Murder rate", pch=19)

abline(reg = lm(state_data$Murder ~ state_data$Frost), col = "red", lwd = 2)

#correlation matrix
aa<-state_data[4:10]
corr<-cor(aa)

library(ggcorrplot)
ggcorrplot(corr)


```

Ans: from the above graph we can say variables like Illiteracy rate, HSGrad, Frost and LifeExp shows strong trends when drawn with Murder, hence we can say these have bivariate relationship with Murder. 

The diagrams and the numerical description states that the relationship is a linear relationship. A linear
relationship can be represented by alinear equation. In some cases as the x-values increase, the
y-values increase as well. So, the slope is positive. In some case as x-value increases y-value decrease which is negative slope. Hence we can say it represents linear relationship.

##### (c) Develop a new research question of your own that you can address using the `state` dataset. Clearly state the question you are going to address. Provide at least one visualization to support your exploration of this question. Discuss what you find in your exploration.

Question: Does life expectancy and Frost has any relationship? Does increase in Frost decreases the life expectancy?

```{r}
#plotting HSGrad vs murder rate
plot(state_data$Frost,state_data$LifeExp, main="Frost vs Life Expectancy Scatterplot",
   xlab="Frost ", ylab="Life Expectancy", pch=19)

abline(reg = lm(state_data$LifeExp ~ state_data$Frost), col = "red", lwd = 2)

```
Ans: There is no strong trend between Frost and Life Expectancy as we expected, this means Life Expectancy and Frost are not strongly related and doesn't have bivariate relation. This data gives frost for capital or Large cities and cities have better heating facilities, this can be the reason Frost and LifeExpectancy doesn't show any strong trend.


#### Problem 2: Asking Data Science Questions: Crime and Educational Attainment

In Problem Set 3, you joined data about crimes and educational attainment. Here you will use this new combined dataset to examine questions around crimes in Seattle and the educational attainment of people
living in the areas in which the crime occurred. The combined state dataset is available on the course Canvas website (note: this will be available after all students submit Problem Set 3).


#### (a) Develop a Data Science Question

Develop your own question to address in this analysis. Your question should be specific and measurable, and it should be able to be addressed through a basic analysis of the dataset from Problem Set 3. This analysis must involve at least one hypothesis test. Clearly state what the question is and the suitable null and alternative hypotheses.

Research question: What is the average time of the day when crime occure?

Null hypothesis: Average time of crimes occur at around 1500 hrs( Mu=1500)

Alternative hypothesis: Average time of crimes occure is not at 1500 hrs (true mean is not equal to 1500)

After we get answer to this question, we can further do the analysis of the time of the murder and education related data, hence time of the murder is one important varibale I am considering and would like to explore this question.

#### (b) Describe and Summarize

Briefly summarize the dataset, describing what data exists and its basic properties. Comment on any issues that need to be resolved before you can proceed with your analysis. Provide descriptive statistics of variables of interest.


```{r}
#read file
combined_data<-read.csv("combinedCrimeDataset.csv")

#save this as local df
combined_df <- tbl_df(combined_data)



#descriptive statistics of variables of interest (Occurred.time , )
str(combined_df)
str(combined_df$Occurred.Date)

#to describe the time we will draw the histogram which will show the numbers in more detail

# set up cut-off values 
breaks <- c(0,100,200,300,400,500,600,700,800,900,1000,
            1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400)

# specify interval/bin labels
tags <- c("[0-1)","[1-2)","[2-3)","[3-4)", "[4-5)","[5-6)","[6-7)", "[7-8)","[8-9)", "[9-10)",
          "[10-11)","[11-12)","[12-13)","[13-14)", "[14-15)","[15-16)","[16-17)","[17-18)",
          "[18-19)","[19-20)","[20-21)","[21-22)","[22-23)","[23-24)")

# bucketing values into bins
group_tags <- cut(combined_data$Occurred.Time, 
                  breaks=breaks, 
                  include.lowest=TRUE, 
                  right=FALSE, 
                  labels=tags)



combined_data$time<-group_tags

plot(combined_data$time,
main="Number of crime at the time of day",
xlab="Hours of a day",
ylab="Number of Crimes",
col="blue")

x=combined_data$Occurred.Time

#lets see this numerical data into their quartile ranges, which is one more 
#way of descxriptive analysis of time variable
library("ggpubr")
ggboxplot(x, ylab = "hrs", xlab = FALSE,ggtheme = theme_minimal())

```
Ans: This is crime dataset combined with educational attainment in the area of the state. It has variables like Report number, date occured, time occured, date reported, time reported, crime category, 
description, sector, Neighborhood relatd to crime. It has data related to location and different grades in that area.

Issue : we have Occured.Time variable and these values are continuous numerical but we dont know the ranges to esimates the number of crimes at pericular hour, hence we have to  create new variable Time which is time beans for better analysis.

I have done descriptive statistics for time variable which was the variable of interest for my research question.


#### (c) Data Analysis

Use the dataset to provide empirical evidence to answer your question from part (a). Discuss your results. Provide at least one visualization to support your narrative. (NOTE: you will not be graded on whether you see statistically significant results but rather on your interpretation of findings)


```{r}


#Null hypothesis "Average time of crimes occur at around 1500 hrs( Mu=1500)


bb<-data.frame(table(combined_data$time))
bb$cumfreq<-bb$Freq/sum(bb$Freq)
samplemean<-mean(combined_data$Occurred.Time)
samplestd<-(var(combined_data$Occurred.Time))^(0.5)
samplesize<-length(combined_data$Occurred.Time)

hyptest<-(t.test(combined_data$Occurred.Time))


x=combined_data$Occurred.Time

#lets to the t test considering the true value of the mean as 1500
y<- t.test(x, mu = 1500, alternative = "two.sided")
y

library(moonBook)
library(webr)
plot(y)

#t.test(x, mu = samplemean, alternative = "two.sided")

```
Ans: After looking at the p-value is less than 0.05 and we can reject null hypothesis. This means Average time of crimes occure is not at 1500 hrs as we thought after looking at quartile range for the variabke Occured.Time.
The visualization shows the result of the test and it is sufficient to reject the null hypothesis.

#### (d) Reflect and Question

Comment on the questions (and answers) in this analysis. Were you able to adequately answer your question? Is there additional data that would help provide a more clear picture of the problem you are analyzing?

Ans: I feel i was able to answer the research question I considered, I had to do some basic changes to the Occured.Time variable to show the and analize it efficiently, but I feel like the data was suffiencient to answer the question and reject the null hypothesis based on test.I do not think there is need of any additional data to answer this research question.
I can also to the t-test with true value of the mean as sample mean and understand how it affect the reuslts.


#### Problem 3: Sampling with and without Replacement

In the following situations assume that half of the specified population wears glasses and the other half does not.

##### (a) Suppose you're sampling from a room with 10 people. What is the probability of sampling two people wearing glasses in a row when sampling with replacement? What is the probability when sampling without replacement?

```{r}
#number 1 says people with glasses and number 0 says people without glasses
dataset <- c(1,0,1,0,1,0,1,0,1,0)
class(dataset)

sample(dataset, 10, replace = TRUE, prob = NULL)

replace <- (0.5)^2
replace
without_replace <- (0.5*(4/9))
without_replace

```

##### (b)  Now suppose you're sampling from a stadium with 10,000 people. What is the probability of sampling two people wearing glasses in a row when sampling with replacement? What is the probability when sampling without replacement?

```{r}
with_replace <- (0.5)^2
with_replace
no_replace <- (0.5*(4999/9999))
no_replace
```

##### (c) We often treat individuals who are sampled from a large population as independent. Using your findings from parts (a) and (b), explain whether or not this assumption is reasonable.
ans: 
we can say the assumption of independence in large groups is reasonable.

When sampling without replacement, the probability of sampling two people with glasses in a row is 0.2222222 in the 10 person group and 0.249975 in the 10000 person group. 0.249975 is much closer to the value of 0.25 which is seen when sampling with replacement.

When the population was small (10 people) there was a significant variation between the probabilities of getting two people with glasses in a row in the two cases of with and without replacement. However, when the population size was huge (10000 people) the probabilities of getting 2 people with glasses in a row in both the cases of with and without replacement were nearly same.
