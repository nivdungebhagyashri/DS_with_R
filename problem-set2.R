---
title: 'IMT 573: Problem Set 2 - Working with Data'
author: "Bhagyashri Nivdunge"
date: 'Due: Tuesday, October 15, 2019'
output:
  html_document:
    df_print: paged
---

##### Collaborators: 

Krutika Mohanty

https://dplyr.tidyverse.org/

##### Instructions:

Before beginning this assignment, please ensure you have access to R and RStudio; this can be on your own personal computer or on the IMT 573 R Studio Server. 

1. Download the `problemset2.Rmd` file from Canvas or save a copy to your local directory on RStudio Server. Open `problemset2.Rmd` in RStudio and supply your solutions to the assignment by editing `problemset2.Rmd`. 

2. Replace the "Insert Your Name Here" text in the `author:` field with your own full name. Any collaborators must be listed on the top of your assignment. 

3. Be sure to include well-documented (e.g. commented) code chucks, figures, and clearly written text chunk explanations as necessary. Any figures should be clearly labeled and appropriately referenced within the text. Be sure that each visualization adds value to your written explanation; avoid redundancy -- you do not need four different visualizations of the same pattern.

4.  Collaboration on problem sets is fun and useful, and we encourage it, but each student must turn in an individual write-up in their own words as well as code/work that is their own.  Regardless of whether you work with others, what you turn in must be your own work; this includes code and interpretation of results. The names of all collaborators must be listed on each assignment. Do not copy-and-paste from other students' responses or code.

5. All materials and resources that you use (with the exception of lecture slides) must be appropriately referenced within your assignment.  

6. Remember partial credit will be awarded for each question for which a serious attempt at finding an answer has been shown. Students are \emph{strongly} encouraged to attempt each question and to document their reasoning process even if they cannot find the correct answer. If you would like to include R code to show this process, but it does not run withouth errors you can do so with the `eval=FALSE` option.

```{r example chunk with a bug, eval=FALSE, include=FALSE}
a + b # these object dont' exist 
# if you run this on its own it with give an error
```

7. When you have completed the assignment and have **checked** that your code both runs in the Console and knits correctly when you click `Knit PDF`, rename the knitted PDF file to `ps2_YourLastName_YourFirstName.pdf`, and submit the PDF file on Canvas.

##### Setup

In this problem set you will need, at minimum, the following R packages.

```{r Setup, message=FALSE}
# Load standard libraries
library(tidyverse)
library(nycflights13)
```

#### Problem 1: Describing the NYC Flights Data

In this problem set we will continue to use the data on all flights that departed NYC (i.e. JFK, LGA or EWR) in 2013. Recall, you can find this data in the `nycflights13` R package. Load the data in R and ensure you know the variables in the data.  Keep the documentation of the dataset (e.g. the help file) nearby.

In Problem Set 1 you started to explore this data. Now we will perform a more thorough description and summarization of the data, making use of our new data manipulation skills to answer a specific set of questions. When answering these questions be sure to include the code you used in computing empirical responses, this code should include code comments. Your response should also be accompanied by a written explanation, code alone is not a sufficient response.

##### (a) Describe and Summarize

Answer the following questions in order to describe and summarize the `flights` data. 

\begin{enumerate}
\item How many flights out of NYC are there in the data?
```{r}

# Load the nycflights13 library which includes data on all
data = library(nycflights13)
# flights departing NYC
data(flights)
# Note the data itself is called flights, we will make it into a local df
# for readability
flights <- tbl_df(flights)
# Look at the help file for information about the data
# ?flights
flights
# summary(flights)

```


ans : data 336776 flights departing from NYC

\item How many NYC airports are included in this data?  Which airports are these?
```{r}

#get count of uniuqe values in origin column of flights dataframe
length(unique(flights$origin))
unique(flights$origin)

```
ans: Data is from 3 different NYC airports, names are "EWR" "LGA" "JFK"

\item Into how many airports did the airlines fly from NYC in 2013?
```{r}

#check how many different years this data contains
unique(flights$year)

#we contain data only from 2013 hence number of destinations are:

length(unique(flights$dest))
unique(flights$dest)

```

Ans: Airplanes fly from NYC to 105 different airport


\item How many flights were there from NYC to Seattle (airport code \texttt{SEA})?

```{r}

#lets find code for seattle airport
unique(flights$dest)

#seattle airport is 'SEA'

#filter flights data with destination code as seattle

filter(flights,flights$dest == 'SEA')


```
ans: there 3923 flights fron NYC to seattle airport

\item Were there any flights from NYC to Spokane \texttt{(GEG)}?
```{r}

#lets find code for spokane airport is there in list of destination airport
unique(flights$dest)


#there is no 'GEG' code in unique destinations codes

#lets filter flights data by spokane as a destination
filter(flights,flights$dest == 'GEG')

```

ans : No there are no flights from NYC to spokane

\item Are there missing destination codes? (i.e. are there any destinations that do not look like valid airport codes (i.e. three-letter-all-upper case)?)

```{r}

#lets find codes for all the destinations
unique(flights$dest)

```

ans: all destinations are valid with three upper case characters

\end{enumerate}

##### (b) Reflect and Question

What are your thoughts on the questions (and answers) so far?  Were you able to answer all of these questions?  Are all questions well defined?  Is the data suitable for answering all these?

ans: 
Yes all the questions were very clear and well defined. Data looked clear and clean to answer all these questions. It was not very difficult to answer these questions with the given data.

I could answer all these questions with minimum analysis on the the data.



#### Problem 2: NYC Flight Delays

Flights are often delayed.  Let's look at closer at this topic using the NYC Flight dataset. Answer the following questions about flight delays using the `dplyr` data manipulation verbs we talked about in class.

ans:

```{r}
library(dplyr)

#check if there are na in dep_time
sum(is.na(flights$dep_time))

flights_no_na <- flights %>% filter_at(vars(dep_delay),all_vars(!is.na(.)))
flights_no_na


#lets use flights after removing na to see number of delayed flights
flights_with_delay <- flights_no_na %>% filter(dep_delay>0) 
flights_with_delay

```

Number of flights which got delayed is : 128,432 hence we can say flights often get delayed

##### (a) Typical Delays

What is the typical delay for a flight in this data?

```{r}

#flights with departure delay
flights_with_delay

#lets use the same data we creayed 

flights_with_delay %>% summarize(mean = mean(dep_delay))

#flights with arrival delay

flights_no_na2 <- flights %>% filter_at(vars(arr_delay),all_vars(!is.na(.)))
flights_no_na2

#lets use flights with arrival delay
flights_with_arr_delay <- flights_no_na %>% filter(arr_delay>0) 
flights_with_arr_delay

#average arrival delay
flights_with_arr_delay %>% summarize(mean = mean(arr_delay))

```


ans: avergae departure delay is 39.37323 mins
     avergae arrival delay is 40.3425	mins

##### (b) Defining Flight Delays

What definition of flight delay did you use to answer part (a)? Did you do any specific exploration and description of this variable prior to using it? If no, please do so now. Is there any missing data?  Are there any implausible or invalid entries?  

ans: 

I first checked if there are any flights with missing departure or arrival delays, I removed those rows from my calculations first of all.

After removing NA, I created a dataframe by filtering only all the rows which has delay 0 or less than zero, because these are not actual delays. Also negative values are not actual delays, I don't want to consider these values in calculating average delay, which will cause my average to drop below actaul value.

After getting all the rows with actual delays, I calculated mean of the dep_delay column and mean of arr_delay.

Basically delay can be dep_delay or arr_delay or combination of both.



##### (c) Delays by Destination

Now, compute flight delay by destination. Which are the worst three destinations from NYC if you don't like flight delays? Be sure to justify your delay variable choice. 

```{r}

#group flights by destination and then take average of 

flights_delay_by_dest <- flights_with_delay %>% group_by(dest) %>% summarise_at(vars(dep_delay,arr_delay), funs(mean(., na.rm=TRUE)))


flights_delay_by_dest$total_delay <- flights_delay_by_dest$dep_delay + flights_delay_by_dest$arr_delay

flights_delay_by_dest<-flights_delay_by_dest %>% arrange(desc(total_delay))
flights_delay_by_dest
```

Worst three destinations and their avergae total delays (dep_delay + arr_delay):

TVC : 131.250794	
TUL : 129.644833
TYS : 128.236693	

Worst three destinations if we consider only arrival delays for the destinations:

TUL : 64.9704142
CAE : 62.5633803
TYS : 62.5107143


##### (d) Seasonal Delays

Flight delays may be partly related to weather, as you may have experienced yourself. We do not have weather information here but let's analyze how delays are related to season. Which seasons have the worst flights delays? Why might this be the case? In your communication of your analysis, use one graphical visualization and one tabular respresentation of your findings.

\textcolor{blue}{Hint: you may want to create a date variable.}

```{r}

#Creating a date variable
flights$date <- with(flights, ISOdate(year = 2013, month, day))


#let's see seasonal pattern for departure delay

#group flights by month and take average of departure delay for each month
flights_by_month <- flights %>% group_by(month)%>% summarise_at(vars(dep_delay), funs(mean(., na.rm=TRUE)))
#flights grouped by month
flights_by_month 
#Visualize this data
plot(flights_by_month ,type="l")


#let's see seasonal pattern for departure delay

#group flights by month and take average of departure delay for each month
flights_by_month_arr <- flights %>% group_by(month)%>% summarise_at(vars(arr_delay), funs(mean(., na.rm=TRUE)))
#flights grouped by month
flights_by_month_arr
#Visualize this data
plot(flights_by_month_arr ,type="l")

```
If we look at Departure Delay and Arrival Delay, both show maximum delays in month of June and July i.e. Summer.
We can safely say maxium delays arrive in Summer season.

After Summer you can see December is a month where delays are more, so we can say even in Winter in Holiday season there are fligt delays.


##### (e) Challenge Your Results

After completing the exploratory analyses from Problem 2, do you have any concerns about your findings? How well defined was your original question? Do you still believe this question can be answered using this dataset? Comment on any ethical and/or privacy concerns you have with your analysis. 

Ans:

It was difficult to decide the delay variable, I was not sure if I should consider only departure delays or arrival delays or total delay which is sum of these two.

Also delays have negative values, I thought considering negative values in delay will give me wrong result but it can be wrong if we consider some other parameters which I don't understand.

I still belive this data is sufficient to do analysis but with the sample size our answers might change.

#### Problem 3: Let's Fly Across the Country!

#### (a) Describe and Summarize

Answer the following qeustions to describe and summarize the `flights` data, focusing on flights from New York to Portland, OR (airport code `PDX`).

\begin{enumerate}
\item How many flights were there from NYC airports to Portland in 2013?

```{r}

#filter destinations with portland code 'PDX'

flight_to_portland<-filter(flights,flights$dest == 'PDX')

#count number of rows
print(nrow(flight_to_portland))

```
ans :
there are 1354 flights from NYC to Portland in 2013


\item How many airlines fly from NYC to Portland?

```{r}
# a dataframe with only portland as a destination
flight_to_portland

#lets find all the unique carriers in this dataframe
unique(flight_to_portland$carrier)

```
Ans: there are pnly 3 airlines which fly from NYC to Portland : "DL" "UA" "B6"

\item Which are these airlines (find the 2-letter abbreviations)?  How many times did each of these go to Portland?

```{r}

#lets group by carrier and count the number of flights of each carrier
flight_to_portland_by_carrier <- flight_to_portland %>% group_by(carrier) %>% summarize(count = n())

#display
flight_to_portland_by_carrier
```
Ans: There are:

325	 flights of B6 airline
458 flights of DL airline
571	 flights of UA airline

\item How many unique airplanes fly from NYC to PDX? \\ \textcolor{blue}{Hint: airplane tail number is a unique identifier of an airplane.}

```{r}

#lets find out unique airplanes from NYC to PDX
unique(flight_to_portland$tailnum)

#number of these unique airplanes
length(unique(flight_to_portland$tailnum))


```
Ans: there are  492 unique flights from NYC to Portland


\item How many different airplanes flew from each of the three NYC airports to Portland?
```{r}
#lets check if all three NYC airports has flights to Portland
unique(flight_to_portland$origin)

#let's calculate unique airplanes flying from these two NYC airports to Portland

distinct_airplanes_from_NYCairports<-flight_to_portland %>% group_by(origin) %>% summarize(count = n_distinct(tailnum))

#display 
distinct_airplanes_from_NYCairports
```

Ans: From EWR there are 297 unique airplanes and from JFK there are 195 unique airplanes

\item What percentage of flights to Portland were delayed at departure by more than 15 minutes?

```{r}


delay_more_than_15 <- filter(flight_to_portland,flight_to_portland$dep_delay > 15)

print((nrow(delay_more_than_15)/nrow(flight_to_portland)) *100)

```
There are 26.67% fligts to portland which got delayed by more than 15 minutes

\item Is one of the New York airports noticeably worse in terms of departure delays for flights to Portland than others?
```{r}

flight_to_portland_delayed <- filter(flight_to_portland,flight_to_portland$dep_delay >0)

flight_to_portland_delayed_origin <- flight_to_portland_delayed  %>% group_by(origin) %>% summarize(mean = mean(dep_delay))

flight_to_portland_delayed_origin
```

JFK airport from NYC has more delay for flights going to Portland. But also the difference between the delay for both airports is not really big enough or noticeable.


\end{enumerate}

#### (b) Reflect and Question

What are your thoughts on the questions (and answers) examining flights to Portland?  Were you able to answer all of these questions?  Are all questions well defined?  Is the data suitable for answering all these?

Ans:

Questions were not very difficult or it didn't very complex calculations or code. For me most questions involved basic functions like, filter, summarise, unique, group_by, nrow.

Yes I was able to answer all the questions.

Most of the questions were well defined but it took me some time to understand the question and gather my thoughts around the soultion and write a code for it.

I feel data is suitable to answer all of these questions.


