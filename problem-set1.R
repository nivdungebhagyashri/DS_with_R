
<!-- This syntax can be used to add comments that are ignored during knitting process. -->

##### Collaborators: <!-- BE SURE TO LIST ALL COLLABORATORS HERE! -->
External SOurces : http://soutik.github.io/NYC-Flight-Analysis/

##### Instructions:

Before beginning this assignment, please ensure you have access to R and RStudio; this can be on your own personal computer or on the IMT 573 R Studio Server. 

1. Download the `problemset1.Rmd` file from Canvas or save a copy to your local directory on RStudio Server. Open `problemset1.Rmd` in RStudio and supply your solutions to the assignment by editing `problemset1.Rmd`. 

2. Replace the "Insert Your Name Here" text in the `author:` field with your own full name. Any collaborators must be listed on the top of your assignment. 

3. Be sure to include well-documented (e.g. commented) code chucks, figures, and clearly written text chunk explanations as necessary. Any figures should be clearly labeled and appropriately referenced within the text. Be sure that each visualization adds value to your written explanation; avoid redundancy -- you do no need four different visualizations of the same pattern.

4.  Collaboration on problem sets is fun and useful, and we encourage it, but each student must turn in an individual write-up in their own words as well as code/work that is their own.  Regardless of whether you work with others, what you turn in must be your own work; this includes code and interpretation of results. The names of all collaborators must be listed on each assignment. Do not copy-and-paste from other students' responses or code.

5. All materials and resources that you use (with the exception of lecture slides) must be appropriately referenced within your assignment.  

6. Remember partial credit will be awarded for each question for which a serious attempt at finding an answer has been shown. Students are \emph{strongly} encouraged to attempt each question and to document their reasoning process even if they cannot find the correct answer. If you would like to include R code to show this process, but it does not run withouth errors you can do so with the `eval=FALSE` option as follows:

```{r example chunk with a bug, eval=FALSE}
a + b # these object dont' exist 
# if you run this on its own it with give an error
```

7. When you have completed the assignment and have **checked** that your code both runs in the Console and knits correctly when you click `Knit PDF`, rename the knitted PDF file to `Yps1_ourLastName_YourFirstName.pdf`, and submit the PDF file on Canvas.

##### Setup: 

In this problem set you will need, at minimum, the following R packages.

```{r Setup, message=FALSE}
# Load standard libraries
library(tidyverse)
install.packages("nycflights13", repos = "http://cran.us.r-project.org")
library(nycflights13)
```

#### Problem 1: Exploring the NYC Flights Data

In this problem set we will use the data on all flights that departed NYC (i.e. JFK, LGA or EWR) in 2013. You can find this data in the `nycflights13` R package. 

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

##### (a) Importing and Inspecting Data

Load the data and describe in a short paragraph how the data was collected and what each variable represents. Perform a basic inspection of the data and discuss what you find.

```{r}
flights
#head of the data
head(flights,10)
#tail of the data
tail(flights,10)
#check variables in data
names(flights)
#check headers
flights[1,]
str(flights)
#levels(flights$origin)
unique(flights$carrier)



```

There are 19 columns and 336776 rows in the Dataset. 

Variables:
Year, Month, Day: represents the day of the flight in data,   
dep_time, sched-dep_time, dep_delay: represent all the time data related to flight departures.  
arr_time, sched_arr_time, arr_delay: represents all time data related to arrivals of the flights.   
carrier, flight and tailnum: gives data related to flight to identify individual filghts based on number and carrier.  
origin and dest: these columns are origin location and destination locations for the flight.   
distance, hour, minute, time_hour: this data is related to actual journy of the flight to calculates speed, understand the time related questions  

Findings from the data:  
1. we can calculate total delay for flight by adding departure delay and arrival delay  
2. The data given has 3 different airports from NYC (JFK, LGA, EWR) so we can do analysis based on airport location as well  
3. Departure delays has negative values as well and its not considered delay in actual sense  
4. We can calculate flight performance by doing (departure delay + arrival delay))/Air time  
5.There are 15 unique carriers from NYC airport and one value is missing  
6. Flights connects to planes via a single variable, tailnum.  
7. Flights connects to airlines through the carrier variable.  
8. Flights connects to airports in two ways: via the origin and dest variables.  
9. Flights connects to weather via origin (the location), and year, month, day and hour (the time).  


##### (b) Formulating Questions

Consider the NYC flights data. Formulate two motivating questions you want to explore using this data. Describe why these questions are interesting and how you might go about answering them.

1. we can find out if there are any seasonal patterns in departure delays for flights from NYC

Why -> We can explore which seasons more has departure delays, if we know the seasons and the period we can try to understand specific patterns in that season that creates delays in departure. We can also compare this data with data from other years and try to find a pattern. 

How -> we will group flights by month of the year 2013, calculate average departure delay for every month and maximum departure delay can be found by taking max value. 


2. Is there any relationship between Departure Delay and Arrival Delay

Why <- I want to understand those flights which gets delayed also arrive late? or the delay is recovered and the flights arrive on the same time? or there is negative or positive relationship between Arrival delay and departure delay. This will help us conclude if your flight from NYC got delayed it will arrive late (or not)

How <- we can create a scatterplot of departure delay and arriavl delay for all the flights from NYC, We can also understand if this relationship changes with the change in the airport by grouping flights data by airport.

##### (c) Exploring Data

For each of the questions you proposed in Problem 1b, perform an exploratory data analysis designed to address the question. At a minimum, you should produce two visualizations (graphics or tables) related to each question. Be sure to describe what the visuals show and how they speak to your question of interest. 

```{r Q1 visualization1}
library(dplyr)

#group flights by month and take average of departure delay for each month
flights_by_month <- flights %>% group_by(month)%>% summarise_at(vars(dep_delay), funs(mean(., na.rm=TRUE)))
#flights grouped by month
flights_by_month 
#Visualize this data
plot(flights_by_month ,type="l")

```

The above visualization shows departure delayes are maxium in June, July. It shows summer is the season where there are maxium departure delays for flights from NYC

```{r Q1 visualization2}
# Exploring the seasonal patterns in total number of delayed by Month

library(dplyr)
#create date variable using year, month, day
flights$date <- with(flights, ISOdate(year = 2013, month, day))

#group flights by date and count total departure delay for the that day
flights_by_date <- flights %>% group_by(date) %>% count(dep_delay)

#plot the visualization of date vs delay
plot(x=flights$date,
     y=flights$dep_delay,
     xlab ="Date",
     ylab = "Delayed Flights Count"
     )


```

In the above visualization we see total counts of departure delays plotted against month, which shows departure delays are more in June and July i.e. Summer season also one month of winter i.e. Jan

This shows us that there is a PEAK in delays during June, July & August month and the delays generally fall down during the winter months i.e. October, November, December


##### (c) Visualizations for question 2

```{r Q2 Visulalization 1}

#plot departure delay vs arrival delay and show color coding based on carrier
ggplot(flights , aes(x=dep_delay, y= arr_delay, color= carrier))+ geom_point()

```

We can see in the above visualization, there is a positive relationship between Departure Delays and Arrival Delays, this means number of arrival delays will increase with the increase in departure delays



```{r Q2 visualization 2}

#group flights by origin
flights_by_airport <- flights %>% group_by(origin)
#plot departure delay vs arrival delay for this data grouped by origin
ggplot(flights_by_airport , aes(x=dep_delay, y= arr_delay, color= origin))+ geom_point()

```

By this visualization, I am trying to understand if the relation between departure delay and arrival delay changes with Airport location of the departure, but looks like even after grouping by airport, departure delay and arrival delay has a positive relation.


##### (d) Challenge Your Results

After completing the exploratory analyses from Problem 1c, do you have any concerns about your findings? How well defined was your original question? Do you still believe this question can be answered using this dataset? Comment on any ethical and/or privacy concerns you have with your analysis. 


1. In some visualization where I created scatterplot with geom_point, 9430 rows got removed because it had missing values, if we had these missing values in our data in first place, result might have been something different and our results would have been more accurate.

2. If we had more data and realistic samples, I feel the relationship between departure delays and arrival delays could be studied in a better way. Currently it is showing positive relation between departure delay and arrival delay, but I doesn't show any cases where there is different kind of relation, I am not sure if the data is biased or not well collected or data is insuffiecient.

3. From question 1 even I figure out that most delays occure in Summer, I cannot really understand the reason behind this from the data. 

4. Question 1 visualizations show some incosistancy when we created avg delay and delay counts, January shows more delays when calcualted by counting delays

5. Departure delay has some negative values as well, this might change the answer when calculating the average delay when grouped by months

6. If we had some more data like, when the plane was manufactured, we can research if the flight performance is dependent on the age of the plane

7. If had known number of seats in the plane, we can research if performance has any relation with number of seats 

8. Dataset doesn't provide any reasons for delay or fuel consumption, flight diversion. This data would have helped to come to more accurate conclusions. 






