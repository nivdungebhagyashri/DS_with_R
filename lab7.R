---
title: "IMT 573 Lab: Regression"
author: "Bhagyashri Nivdunge"
date: "November 7th, 2019"
output: 
  tufte_handout:
    highlight: tango
---

\marginnote{\textcolor{blue}{Don't forget to list the full names of your collaborators!}}

# Collaborators: 

# \textbf{Instructions:}

Before beginning this assignment, please ensure you have access to R and/or RStudio. 

1. Download the `week7b_lab.Rmd` file from Canvas. Open `week7b_lab.Rmd` in RStudio (or your favorite editor) and supply your solutions to the assignment by editing `week7b_lab.Rmd`. 

2. Replace the "Insert Your Name Here" text in the `author:` field with your own full name.

3. Be sure to include code chucks, figures and written explanations as necessary. Any collaborators must be listed on the top of your assignment. Any figures should be clearly labeled and appropriately referenced within the text. 

4. When you have completed the assignment and have **checked** that your code both runs in the Console and knits correctly when you click `Knit`, rename the R Markdown file to `YourLastName_YourFirstName_lab5b.Rmd`, and knit it into a PDF. Submit the compiled PDF on Canvas.

In this lab, you will use whichever libraries are most useful to you.

```{r Setup, message=FALSE}
# Load some helpful libraries
library(tidyverse)
```

Let's begin by reading in data from the following course:  http://data.princeton.edu/wws509/datasets/#salary. Note that this url will have information on variables in the dataset. Also note that the dataset we will be using was previously used as part of a textbook and is a rather well-known dataset for practicing regression.

## Inspecting the data

#### 1. Read in the data. Is it clean and ready for analysis? What do the variables look like?
```{r}
data <- read.table('http://data.princeton.edu/wws509/datasets/salary.dat', header=TRUE)
summary(data)
nrow(data)
head(data)

```


## Univariate regression

#### 2. Plot the salary vs years in current academic position.

```{r}
library(ggplot2)
ggplot(data, aes(x=yr, y=sl)) + geom_point(color='blue',size=5)
```

#### 3. What is the salary increase associated with each additional year in current academic position? What do the confidence intervals look like?
```{r}
cor(data$sl, data$yr)
fit <- lm(sl~yr,data)
view(fit)
summary(fit)
```


#### 4. What do the residuals look like? Plot and describe them.

```{r}
confint(fit, 'yr', level =0.95)

residuals <- resid(fit)

plotresiduals <- ggplot(data = data.frame(x=data$sl, y=residuals), aes(x=x, y=y)) + geom_point(color='red',size=5)
plotresiduals
```


#### 5. Add the regression line to your plot of the data

```{r}

library(ggplot2)
data <- read.table('http://data.princeton.edu/wws509/datasets/salary.dat', header=TRUE)
mean(data$yr)

ggplot(data, aes(x=yr, y=sl)) + geom_point(color='blue',size=5)
cor(data$sl, data$yr)
cor(data$sl, data$yr)

fit <- lm(sl~yr,data)
view(fit)
summary(fit)

confint(fit, 'yr', level =0.95)

residuals <- resid(fit)

plotresiduals <- ggplot(data = data.frame(x=data$sl, y=residuals), aes(x=x, y=y)) + geom_point(color='red',size=5)
plotresiduals


```


## Multivariate regression

#### 6. Run a multiple regression on salary while including the following variables: yr, yd, rk, dg. What is now the effect of each additional year in current academic position?

```{r}
library(dummies)
rkdummies <- dummy(data$rk)
dgdummies <- dummy(data$dg)

datadummy <- subset(data, select =c ('sl','yr','yd'))
datadummy <- cbind(datadummy,rkdummies)
datadummy <- cbind(datadummy,dgdummies)
```


```{r}
fitdummy <- lm(sl ~., datadummy)
datadummy2 <- subset(datadummy, select = c('sl','yr','yd', 'rkassociate','rkfull','dgdoctorate'))
fitdummy2 <- lm(sl ~., datadummy2)
summary(fitdummy2)
residuals2 <- resid(fitdummy2)

```
```{r}


plotresiduals2 <- ggplot(data = data.frame(x=data$sl, y=residuals2), aes(x=x, y=y)) + geom_point(color='red',size=3)
plotresiduals2 <- plotresiduals2 + stat_smooth(method ="lm", se = FALSE, color = 'red') + geom_point(color='red',size=3)

plotresiduals2
```


#### 7. Did the coefficent change from the previous regression? Is it still statistically significant? Can you explain this?

ans: coeeficient changes from the previous regression, we got coeeficient estimate 752.8 but in this regression we got coeeficient estimate for year 416.56. It is statistically significant because it says adding other variables to the regression changes the coeeficient for year, this means these other variables are also affecting.

#### 8. What do the residuals look like? Plot and describe them.
```{r}
plotresiduals <- plotresiduals + 
  stat_smooth(method ='lm', se=FALSE, color='red')+
  xlim(14000, 38000)+
  ylim(-7500,7500)+
  labs(title="First residual plot",x = 'residual', y='salary')
plotresiduals
```


## Adding randomness

#### 9. create 20 new variables, each with randomly sampled data from a distribution of your choice. Add these to the above regression.

```{r}
#random variables using normal distribution
datadummy3 = datadummy2
set.seed(124)
datadummy3$var1 <- rnorm(52, 22, 5)
datadummy3$var2 <- rnorm(52, 35, 8)
datadummy3$var3 <- rnorm(52, 36, 6)
datadummy3$var4 <- rnorm(52, 37, 8)
datadummy3$var5 <- rnorm(52, 25, 9)
datadummy3$var6 <- rnorm(52, 22, 2)
datadummy3$var7 <- rnorm(52, 42, 3)
datadummy3$var8 <- rnorm(52, 37, 5)
datadummy3$var9 <- rnorm(52, 46, 4)
datadummy3$var10 <- rnorm(52, 46, 4)
datadummy3$var11 <- rnorm(52, 46, 4)
datadummy3$var12 <- rnorm(52, 46, 4)
datadummy3$var13 <- rnorm(52, 46, 4)
datadummy3$var14 <- rnorm(52, 46, 4)
datadummy3$var15 <- rnorm(52, 46, 4)
datadummy3$var16 <- rnorm(52, 46, 4)
datadummy3$var17 <- rnorm(52, 46, 4)
datadummy3$var18 <- rnorm(52, 46, 4)
datadummy3$var19 <- rnorm(52, 46, 4)
datadummy3$var20 <- rnorm(52, 46, 4)

```


#### 10. Did the coefficent change from the previous regression? Is it still statistically significant?

```{r}

fitdummy3 <- lm(sl ~., datadummy3)
summary(fitdummy3)

```
ans: yes coeeficients has changes after adding more variables but these variables are still statistically significant.


#### 11. What do the residuals look like? Plot and describe them.

```{r}
residuals3 <- resid(fitdummy3)
plotresiduals3 <- ggplot(data = data.frame(x=data$sl, y=residuals3), aes(x=x, y=y)) + geom_point(color='red',size=3)
plotresiduals3 <- plotresiduals3 + stat_smooth(method ="lm", se = FALSE, color = 'red') + geom_point(color='red',size=3)

plotresiduals3
```


#### 12. Did the model fit improve (R-sq)? Is this expected? Why?


#### 13. How did the model fare compared to previous models with respect to AIC/BIC?
```{r}
#start with empty model
#get list of possible explanatory varibales
#while new AIC < previous AIC
  #for very variable 
    # - add it to model
    # - calculate the AIC
  #selec t variable with lowest AIC and add to model

summary(fit)
summary(fitdummy2)
summary(fitdummy3)

AIC(fit)
BIC(fit)

AIC(fitdummy2)
BIC(fitdummy2)

AIC(fitdummy3)
BIC(fitdummy3)
```
```{r}

sxDummies <-dummy(data$sx)
dataDummyAll <- cbind(datadummy,sxDummies)
view(dataDummyAll)
```



## Forward and backward selection

#### Run forward selection on all the data using salary as your exogenous variable. What does your final model look like?

1. start with an empty model
2. get list of possible explanatory variables
while new AIC <  previous AIC
for every possible variable
a. add it to my model
b. calculate the AIC
4. select the model with the lowest AIC and add to model

```{r}
currentRegression <- character()
possibleRegressions <- names(dataDummyAll[,-1])
bestAic=Inf
```

```{r}
for (var in possibleRegressions)
{
  temp <- currentRegression
  temp[length(temp)+1] <- var
  temp <- c("sl",temp)
  currentLm <- lm(sl ~., dataDummyAll[,temp])
  currentAic <- AIC(currentLm)
  if (currentAic < bestAic){
    toAdd <-var
    currentBestAic <- currentAic
  }
}
```
#### Run backward selection on all the data using salary as your exogenous variable. What does your final model look like?
