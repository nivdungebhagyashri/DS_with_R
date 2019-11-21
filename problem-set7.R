---
title: 'IMT 573: Problem Set 7 - Regression - Solutions'
author: "Bhagyashri Nivdunge"
date: 'Due: Tuesday, November 19, 2019'
output: pdf_document
header-includes:
- \newcommand{\benum}{\begin{enumerate}}
- \newcommand{\eenum}{\end{enumerate}}
- \newcommand{\bitem}{\begin{itemize}}
- \newcommand{\eitem}{\end{itemize}}
---

<!-- This syntax can be used to add comments that are ignored during knitting process. -->

##### Collaborators: <!-- BE SURE TO LIST ALL COLLABORATORS HERE! -->

Hrishika Shetty

https://rpubs.com/bmckinz/183882
https://medium.com/@kmsbmadhan/crime-detection-with-boston-housing-data-set-using-linear-regression-in-r-part-1-b94fc2c4f8b2
http://www.science.smith.edu/~jcrouser/SDS293/labs/lab12-r.html


##### Instructions:

Before beginning this assignment, please ensure you have access to R and RStudio; this can be on your own personal computer or on the IMT 573 R Studio Server. 

1. Download the `problemset7.Rmd` file from Canvas or save a copy to your local directory on RStudio Server. Open `problemset7.Rmd` in RStudio and supply your solutions to the assignment by editing `problemset7.Rmd`. 

2. Replace the "Insert Your Name Here" text in the `author:` field with your own full name. Any collaborators must be listed on the top of your assignment. 

3. Be sure to include well-documented (e.g. commented) code chucks, figures, and clearly written text chunk explanations as necessary. Any figures should be clearly labeled and appropriately referenced within the text. Be sure that each visualization adds value to your written explanation; avoid redundancy -- you do not need four different visualizations of the same pattern.

4.  Collaboration on problem sets is fun and useful, and we encourage it, but each student must turn in an individual write-up in their own words as well as code/work that is their own.  Regardless of whether you work with others, what you turn in must be your own work; this includes code and interpretation of results. The names of all collaborators must be listed on each assignment. Do not copy-and-paste from other students' responses or code.

5. All materials and resources that you use (with the exception of lecture slides) must be appropriately referenced within your assignment.  

6. Remember partial credit will be awarded for each question for which a serious attempt at finding an answer has been shown. Students are \emph{strongly} encouraged to attempt each question and to document their reasoning process even if they cannot find the correct answer. If you would like to include R code to show this process, but it does not run without errors, you can do so with the `eval=FALSE` option. (Note: I am also using the `include=FALSE` option here to not include this code in the PDF, but you need to remove this or change it to `TRUE` if you want to include the code chunk.)

```{r example chunk with a bug, eval=FALSE, include=FALSE}
a + b # these object dont' exist 
# if you run this on its own it with give an error
```

7. When you have completed the assignment and have **checked** that your code both runs in the Console and knits correctly when you click `Knit PDF`, rename the knitted PDF file to `ps7_YourLastName_YourFirstName.pdf`, and submit the PDF file on Canvas.

##### Setup

In this problem set you will need, at minimum, the following R packages.

```{r Setup, message=FALSE}
# Load standard libraries
library(tidyverse)
library(MASS) # Modern applied statistics functions
```

\textbf{Housing Values in Suburbs of Boston}

In this problem we will use the Boston dataset that is available in the \texttt{MASS} package. This dataset contains information about median house value for 506 neighborhoods in Boston, MA. Load this data and use it to answer the following questions.

\benum

\item Describe the data and variables that are part of the \texttt{Boston} dataset. Tidy data as necessary.

```{r}

library(MASS)

housing <- Boston

#check data
head(housing)
summary(housing)

#check for NA
colnames(housing)[colSums(is.na(housing)) > 0]

#check for na
sum(is.na(housing))
```
Ans: 
Data description

crim - per capita crime rate by town
zn - proportion of residential land zoned for lots over 25,000 sq.ft.
indus - proportion of non-retail business acres per town.
chas - Charles River dummy variable (1 if tract bounds river; 0 otherwise)
nox - nitric oxides concentration (parts per 10 million)
rm- average number of rooms per dwelling
age - proportion of owner-occupied units built prior to 1940
dis - weighted distances to five Boston employment centres
rad - index of accessibility to radial highways
tax - full-value property-tax rate per $10,000
ptratio - pupil-teacher ratio by town
black - 1000(Bk - 0.63)^2 where Bk is the proportion of blacks by town
lstat - % lower status of the population
medv - Median value of owner-occupied homes in $1000's

There are no mising values in this dataset to delete any rows.
There are no categorical varibles, there is no create dummy numerical variables from these categorical. So we can ignore that step.There is no need to do any tidying on data right now.


\item Consider this data in context, what is the response variable of interest?

ans:  consider medv is the response and the other variables are predictors.
  
\item For each predictor, fit a simple linear regression model to predict the response. In which of the models is there a statistically significant association between the predictor and the response? Create some plots to back up your assertions. 

```{r}
#medv vs crim linear regression model
lm1=lm(medv ~ crim, data = Boston)
summary(lm1)

#medv vs zn linear regression model
lm2= lm(medv ~ zn, data = Boston)
summary(lm2)

#medv vs indus linear regression model
lm3=lm(medv ~ indus, data = Boston)
summary(lm3)

#medv vs chas linear regression model
lm4=lm(medv ~ chas, data = Boston)
summary(lm4)

#medv vs nox linear regression model
lm5 = lm(medv ~ nox, data = Boston)
summary(lm5)

#medv vs rm linear regression model
lm6= lm(medv~ rm, data = Boston)
summary(lm6)

#medv vs age linear regression model
lm7 = lm(medv ~ age, data = Boston)
summary(lm7)

#medv vs dis linear regression model
lm8=lm(medv ~ dis, data = Boston)
summary(lm8)

#medv vs rad linear regression model
lm9= lm(medv ~ rad, data = Boston)
summary(lm9)

#medv vs tax linear regression model
lm10=lm(medv ~ tax, data = Boston)
summary(lm10)

#medv vs ptratio linear regression model
lm11=lm(medv ~ ptratio, data = Boston)
summary(lm11)

#medv vs black linear regression model
lm12=lm(medv ~ black, data = Boston)
summary(lm12)

#medv vs lstat linear regression model
lm13=lm(medv ~ lstat, data = Boston)
summary(lm13)


```

ans: looking at the p-value, r-squared and f-statistics, we can say there is strong correlation between repsonse variable and all other predictor variables.

 For all the  variables p-value is too small and we can reject the null hypothesis and conclude that there is a statistical significant relationship between medv and these variables.

While almost all variables are statistically significant, r-squared value is low.

We can plot it to get more understanding.


```{r}
#plot all variable with medv
plot(medv ~ . - medv, data = housing)
```
```{r}
library(corrplot)

#plotting a correlation matrix
B <- cor(housing)
corrplot(B, method = 'circle')
```
After plotting all the variables and finding the correlation,

we can see there is a co-relation between medv and other variables as follows:
High - rm,lstat,indus,ptratio
Medium - crim,tax,rad,nox,zn, black,age
Low  - chas,dis


\item Fit a multiple regression model to predict the response using all of the predictors. Describe your results. For which predictors can we reject the null hypothesis $H_0: \beta_j = 0$?

```{r}

#multiple regression model with medv and other variables
multi = lm(medv ~ . -medv, data = housing)

#summary of the model
summary(multi)

```

ans: 

after fitting the multiple regression model, we can see indus and age has p-value greater than 0.05, hence we cannot reject the null hypothesis for these variables. 

All other variables have p-value less than 0.05 and are statistically significant. We can reject the null hypothesis for these predictors.



\item How do your results from (3) compare to your results from (4)? Create a plot displaying the univariate regression coefficients from (3) on the x-axis and the multiple regression coefficients from part (4) on the y-axis. Use this visualization to support your response.

```{r}

#create a vector with all the univariate regression coefficients 
uni<-vector("numeric",0)
uni<-c(uni,lm1$coefficients[2])
uni<-c(uni,lm2$coefficients[2])
uni<-c(uni,lm3$coefficients[2])
uni<-c(uni,lm4$coefficients[2])
uni<-c(uni,lm5$coefficients[2])
uni<-c(uni,lm6$coefficients[2])
uni<-c(uni,lm7$coefficients[2])
uni<-c(uni,lm8$coefficients[2])
uni<-c(uni,lm9$coefficients[2])
uni<-c(uni,lm10$coefficients[2])
uni<-c(uni,lm11$coefficients[2])
uni<-c(uni,lm12$coefficients[2])
uni<-c(uni,lm13$coefficients[2])

# multiple regression coefficients
multi$coefficients[2:14]

#plotting univariate regression coefficients against multiple regression coefficients
plot(uni, multi$coefficients[2:14], main = 'Univariate vs. Multiple Regression Coefficients', xlab = 'Univariate coefficients', ylab = 'Multiple regression coefficients')

```

ans:
we see coeeficient values are differnt in both the cases,
values for coefficient for variable is different when modelled alone compared to model having all together.
If both the values had been identical we could have been able to see a stright line, in this case both the values are different.

\item Is there evidence of a non-linear association between any of the predictors and the response? To answer this question, for each predictor $X$ fit a model of the form:


  
  $$ Y = \beta_0 + \beta_1 X + \beta_2 X^2 + \beta_3 X^3 + \epsilon $$
  
```{r}


#predict medv using 3rd degree polynomial in crim
nl1<-lm(medv~poly(crim,3),data=housing)
summary(nl1)

#predict medv using 3rd degree polynomial in zn
nl2<-lm(medv~poly(zn,3),data=housing)
summary(nl2)

#predict medv using 3rd degree polynomial in indus
nl3<-lm(medv~poly(indus,3),data=housing)
summary(nl3)

#predict medv using 3rd degree polynomial in chas
nl4<-lm(medv~poly(chas+(chas^2)+(chas^3)),data=housing)
summary(nl4)

#predict medv using 3rd degree polynomial in nox
nl5<-lm(medv~poly(nox,3),data=housing)
summary(nl5)

#predict medv using 3rd degree polynomial in rm
nl6<-lm(medv~poly(rm,3),data=housing)
summary(nl6)

#predict medv using 3rd degree polynomial in age
nl7<-lm(medv~poly(age,3),data=housing)
summary(nl7)

#predict medv using 3rd degree polynomial in dis
nl8<-lm(medv~poly(dis,3),data=housing)
summary(nl8)

#predict medv using 3rd degree polynomial in rad
nl9<-lm(medv~poly(rad,3),data=housing)
summary(nl9)

#predict medv using 3rd degree polynomial in tax
nl10<-lm(medv~poly(tax,3),data=housing)
summary(nl10)

#predict medv using 3rd degree polynomial in ptratio
nl11<-lm(medv~poly(ptratio,3),data=housing)
summary(nl11)

#predict medv using 3rd degree polynomial in black
nl12<-lm(medv~poly(black,3),data=housing)
summary(nl12)

#predict medv using 3rd degree polynomial in lstat
nl13<-lm(medv~poly(lstat,3),data=housing)
summary(nl13)


```
  
ans: p-values suggest:
chas, tax, ptratio, black => does not have non-linear association with medv
crim, zn, induz, rm, age, nox, dis, rad, lstat => does have a non-linear association with medv


\item Consider performing a stepwise model selection procedure to determine the bets fit model. Discuss your results. How is this model different from the model in (4)?

```{r}

#stepwise model selection using both backward and forward selection
stepm=step(lm(medv~. -medv,data=housing),direction="both")
summary(stepm)

```

There is a slight difference in adjusted R-squares, in this case of stepwise model we have slightly higher value of adjusted R-square                 
  
\item Evaluate the statistical assumptions in your regression analysis from (7) by performing a basic analysis of model residuals and any unusual observations. Discuss any concerns you have about your model.

```{r}

#calculating residual

residual <- resid(stepm)
plotresidual <- ggplot(data = data.frame(x=housing$medv, y=residual), aes(x=x, y=y)) + geom_point(color='green',size=3)


#plotting residual
plotresidual <- plotresidual + stat_smooth(method ="lm", se = FALSE, color = 'red') + geom_point(color='blue',size=3)

plotresidual
```
```{r}

#plotting stepwise model selection
plot(stepm)
```


The fitted vs residuals plot shows that there is a clear pattern in the residuals. Furthermore the residuals are not evenly distributed along the 0 line and have obvious outliers which have been specifically annotated. The above reasons show that the stepwise linear model is not a good fit for the data and that there is further room for improvement.

\eenum


