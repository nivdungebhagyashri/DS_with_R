---
title: 'IMT 573: Problem Set 3 - Working With Data II'
author: "Bhagyashri Nivdunge"
date: 'Due: Tuesday, October 22, 2019'
output: pdf_document
---

<!-- This syntax can be used to add comments that are ignored during knitting process. -->

##### Collaborators: <!-- BE SURE TO LIST ALL COLLABORATORS HERE! -->

https://medium.com/@HollyEmblem/joining-data-with-dplyr-in-r-874698eb8898
https://stat.ethz.ch/R-manual/R-devel/library/base/html/substr.html
https://nsaunders.wordpress.com/2010/08/20/a-brief-introduction-to-apply-in-r/
https://datacarpentry.org/R-genomics/04-dplyr.html


Hrishika Shetty

##### Instructions:

Before beginning this assignment, please ensure you have access to R and RStudio; this can be on your own personal computer or on the IMT 573 R Studio Server. 

1. Download the `problemset3.Rmd` file from Canvas or save a copy to your local directory on RStudio Server. Open `problemset3.Rmd` in RStudio and supply your solutions to the assignment by editing `problemset3.Rmd`. 

2. Replace the "Insert Your Name Here" text in the `author:` field with your own full name. Any collaborators must be listed on the top of your assignment. 

3. Be sure to include well-documented (e.g. commented) code chucks, figures, and clearly written text chunk explanations as necessary. Any figures should be clearly labeled and appropriately referenced within the text. Be sure that each visualization adds value to your written explanation; avoid redundancy -- you do not need four different visualizations of the same pattern.

4.  Collaboration on problem sets is fun and useful, and we encourage it, but each student must turn in an individual write-up in their own words as well as code/work that is their own.  Regardless of whether you work with others, what you turn in must be your own work; this includes code and interpretation of results. The names of all collaborators must be listed on each assignment. Do not copy-and-paste from other students' responses or code.

5. All materials and resources that you use (with the exception of lecture slides) must be appropriately referenced within your assignment.  

6. Remember partial credit will be awarded for each question for which a serious attempt at finding an answer has been shown. Students are \emph{strongly} encouraged to attempt each question and to document their reasoning process even if they cannot find the correct answer. If you would like to include R code to show this process, but it does not run without errors, you can do so with the `eval=FALSE` option as follows:

```{r example chunk with a bug, eval=FALSE}
a + b # these object dont' exist 
# if you run this on its own it with give an error
```

7. When you have completed the assignment and have **checked** that your code both runs in the Console and knits correctly when you click `Knit PDF`, rename the knitted PDF file to `ps3_YourLastName_YourFirstName.pdf`, and submit the PDF file on Canvas.

##### Setup: 

In this problem set you will need, at minimum, the following R packages.

```{r Setup, message=FALSE}
# Load standard libraries
library('dplyr')
library('censusr')
library('stringr')
```

#### Problem 1: Joining census data to police reports

In this problem set, we will be joining disparate sets of data - namely: Seattle police crime data, information on Seattle police beats, and education attainment from the US Census. Our ultimate goal is to build a dataset where we can examine questions around crimes in Seattle and the educational attainment of people living in the areas in which the crime occurred.

As a general rule, be sure to keep copies of the original dataset(s) as you work through cleaning (remember data provenance).

##### (a) Importing and Inspecting Crime Data

Load the Seattle crime data (crime_data.csv). You can find more information on the data here: (https://data.seattle.gov/Public-Safety/Crime-Data/4fs7-3vj5). This dataset is constantly refreshed online so we will be using the csv file for consistency. We will henceforth call this dataset the "Crime Dataset." Perform a basic inspection of the Crime Dataset and discuss what you find.

```{r}
# add your R code here
#lets read the csv file from local
crime_data_file <- read.csv(file="crime_data.csv", header=TRUE, sep=",")
#save this as local df
crime_data <- tbl_df(crime_data_file)
#head of the dataframe
head(crime_data,10)
#tail of the dataframe
tail(crime_data,5)
#all the column names in the dataframe
names(crime_data)
str(crime_data)
crime_data[1,]
```
ans: crime_data has 11 columns:
"Report.Number" - crime report number (num)              
"Occurred.Date" - Date when crime occured (Factor)             
"Occurred.Time" - Time when crime occured (int)           
"Reported.Date" - Date when crime was reported (Factor)          
"Reported.Time" - Time when crime was reported (int)            
"Crime.Subcategory" - Subcategory of crime (Factor)       
"Primary.Offense.Description" - Description of the crime (Factor)
"Precinct" , "Sector", "Beat" ,"Neighborhood" - these variable contains address details

There are total 523591 crime reports in the dataset

##### (b) Looking at Years That Crimes Were Committed

Let's start by looking at the years in which crimes were committed. What is the earliest year in the dataset? Are there any distinct trends with the annual number of crimes committed in the dataset?

```{r}
# add your R code here
#lets convert all dates to Date format from factor
crime_data$Occurred.Date <- as.Date(crime_data$Occurred.Date, format = "%m/%d/%Y")
crime_data$Reported.Date <- as.Date(crime_data$Reported.Date, format = "%m/%d/%Y")

#extract year from crime occurred dates column and create new year column
crime_data$Occurred.Year <- format(as.Date(crime_data$Occurred.Date, format="%d/%m/%Y"),"%Y")

#all the distinct years from the year column
unique(crime_data$Occurred.Year )

#minimum value in the year column
min(crime_data$Occurred.Year, na.rm=T)

#we have 1908 as the earliest year in the dataset

#lets find out number if crimes per year
crime_by_year <- crime_data %>% group_by(Occurred.Year) %>% summarize(count = n())

```
ans : It looks like till 1997, number of annual crimes was less 10 but after 1998 it slowly increases and in 2006 it goes above 100, in 2007 it is 627, in 2008 it increased drastically. In 2008 the number was 42793 and it was cinsistently large in upcoming years. But in 2019 it reduced to 15624.


Let's subset the data to only include crimes that were committed after 2011 (remember good practices of data provenance!). Going forward, we will use this data subset.

```{r}
# add your R code here
library("dplyr")          ## load

#filter rows by year>2011
crime_by_year_after_2011 <- filter(crime_data, crime_data$Occurred.Year > 2011)


#lets check number of observations in this dataset after filtering
nrow(crime_by_year_after_2011)

```

##### (c) Looking at Frequency of Beats

How frequently are the beats in the Crime Dataset listed? Are there any anomolies with how frequently some of the beats are listed? Are there missing beats?
```{r}
# add your R code here

#lets count all the NA in beat column
sum(is.na(crime_by_year_after_2011$Beat))

crime_clean_beat <- crime_by_year_after_2011 %>% filter(Beat !="")


#lets see all the distinct values in Beat column
unique(crime_clean_beat$Beat)
length(unique(crime_clean_beat$Beat))

#lets check how frequently beats are listed in dataset
frequency_Percentage <- (nrow(crime_clean_beat)/nrow(crime_by_year_after_2011))*100


#lets calculate frequency percentage for each beat
each_beats_percentage <- crime_clean_beat%>% group_by(Beat) %>% summarize(count = (n()/nrow(crime_clean_beat)*100))


#beat with maximum percentage
max(each_beats_percentage$count)
```
ans: we can see 99.41323 % of the times beats are listed in the dataset. There were some missing beats which had empty strings. crime_clean_beat this is a dataset after removing empty values. 

after calculating percentage of each beat in the dataset, we can calculate which beat has maximum frequency, i.e. K3 has maximum frequency percentage 3.336504. 

##### (d) Importing Police Beat Data and Filtering on Frequency

Load the data on Seattle police beats (police_beat_and_precinct_centerpoints.csv). You can find additional information on the data here: (https://data.seattle.gov/Land-Base/Police-Beat-and-Precinct-Centerpoints/4khs-fz35) and more information on what a police beat is here: https://en.wikipedia.org/wiki/Beat_(police). We will henceforth call this dataset the "Beats Dataset."

```{r}
# add your R code here

#lets read the csv file from local
beats_data_file <- read.csv(file="police_beat_and_precinct_centerpoints.csv", header=TRUE, sep=",")

#save this as local df
beats_dataset <- tbl_df(beats_data_file)
```

Does the Crime Dataset include police beats that are not present in the Beats Dataset? If so, how many and with what frequency do they occur? Would you say that these comprise a large number of the observations in the Crime Dataset or are they rather infrequent? Do you think removing them would drastically alter the scope of the Crime Dataset?

```{r}
# add your R code here

unique_beats <- unique(beats_dataset$Name)

#lets use cleaned beat data from above and compare it with beats from beats_dataset and calculate percentage of total such beats 

unique_crime_beats <- crime_clean_beat %>% filter(!Beat %in% unique_beats)  %>% summarise(beat_vals= paste(unique(Beat),collapse = " "), total = n(),percent = n()/nrow(crime_clean_beat)*100)
unique_crime_beats


```
ans : This show that there are 6 beats which are present in crime dataset but are not there Beats dataset. These beats are S, SS, DET, CTY, WS, K and it contains frequency percentage of 0.004310357 , which can be considered insignificant. Hence we safely remove these beats and it will not affect the scope of the Crime Dataset.

Let's remove all instances in the Crime Dataset that have beats which occur fewer than 10 times across the Crime Dataset. Also remove any observations with missing beats. After only keeping years of interest and filtering based on frequency of the beat, how many observations do we now have in the Crime Dataset?

```{r}
# add your R code here

#we are already using cleaned beats data 

#lets group by Beat and summarise with count and filter all the rows which has frequency less than 10
beats_with_freq_lessthan_10 <- crime_clean_beat %>% group_by(Beat) %>% summarise(count = n()) %>% filter(count<10)

#lets get all the beats with less than 10 frequency
beats_with_freq_lessthan_10_names <-beats_with_freq_lessthan_10$Beat 


#lets remove rows with beats frequency less than 10
after_removing_less_than_10_freq <- crime_clean_beat %>% filter(!Beat %in% beats_with_freq_lessthan_10_names)



nrow(after_removing_less_than_10_freq)
```

ans: After only keeping years of interest and filtering based on frequency of the beat we have 347,980 observations left.

##### (e) Importing and Inspecting Police Beat Data

To join the Beat Dataset to census data, we must have census tract information. 

First, let's remove the beats in the Beats Dataset that are not listed in the (cleaned) Crime Dataset.

Then, let's use the censusr package to extract the 15-digit census tract for each police beat using the corresponding latitude and longitude. Do this using each of the police beats listed in the Beats Dataset. Do not use a for-loop for this but instead rely on R functions (e.g. the 'apply' family of functions). Add a column to the Beat Dataset that contains the 15-digit census tract for the each beat. (HINT: you may find censusr's call_geolocator_latlon function useful)

```{r}
# add your R code here

#unique beats in cleaned crime data
unique_beats_crimedata <- unique(crime_clean_beat$Beat)

#let's remove the beats in the Beats Dataset that are not listed in the cleaned Crime Dataset
beats_data_updated <- beats_dataset %>% filter(Name %in% unique_beats_crimedata)


#lets get census data
census_data_file <- read.csv(file="census_edu_data.csv", header=TRUE, sep=",")


#save this as local df
census <- tbl_df(census_data_file)
 

library("censusr")

#lets calculate the census tract using call_geolocator_latlon
beats_data_updated$census_code <- apply(beats_data_updated, 1, function(row) call_geolocator_latlon(row['Latitude'], row['Longitude']))

beats_data_updated


```

We will eventually join the Beats Dataset to the Crime Dataset. We could have joined the two and then found the census tracts for each beat. Would there have been a particular advantage/disadvantage to doing this join first and then finding census tracts? If so, what is it? (NOTE: you do not need to write any code to answer this)

ans: There are some beats which are not common in crime data and beats dataset, if we had taken inner join while joining these two dataset, there was a possibility we would have missed on few beats and census code for these beats would not have been calculated. If we take outer join to join these two tables then it will not make a differenece if we calculate census track code before or after.


##### (f) Extracting FIPS Codes

Once we have the 15-digit census codes, we will break down the code based on information of interest. You can find more information on what these 15 digits represent here: https://transition.fcc.gov/form477/Geo/more_about_census_blocks.pdf.

First, create a column that contains the state code for each beat in the Beats Dataset. Then create a column that contains the county code for each beat. Find the FIPS codes for WA State and King County (the county of Seattle) online. Are the extracted state and county codes what you would expect them to be? Why or why not?

```{r}
# add your R code here

#adding column for state code
beats_data_updated$state_code <-  substr(beats_data_updated$census_code, 0, 2) 

#adding column for county code
beats_data_updated$county_code <-  substr(beats_data_updated$census_code, 3, 5) 


beats_data_updated
```
ans: after checking online codes for Washington and King County we get Wahington state code 53 and King County code 033. Even in our dataset we have got State_code 53 and County_code 033. Given this is seattle police dataset, it is not surprising that the state_code and county_code we got matches with Washington State and King County.


##### (g) Extracting 11-digit Codes

The census data uses an 11-digit code that consists of the state, county, and tract code. It does not include the block code. To join the census data to the Beats Dataset, we must have this code for each of the beats. Extract the 11-digit code for each of the beats in the Beats Dataset. The 11 digits consist of the 2 state digits, 3 county digits, and 6 tract digits. Add a column with the 11-digit code for each beat.

```{r}
# add your R code here

#taking substring of 11 digits from census_code
beats_data_updated$new_11_digit_code <- substr(beats_data_updated$census_code, 0, 11)
beats_data_updated
```

##### (h) Extracting 11-digit Codes From Census

Now, we will examine census data (census_edu_data.csv). The data includes counts of education attainment across different census tracts. Note how this data is in a 'wide' format and how it can be converted to a 'long' format. For now, we will work with it as is.

The census data contains a "GEO.id" column. Among other things, this variable encodes the 11-digit code that we had extracted above for each of the police beats. Specifically, when we look at the characters after the characters "US" for values of GEO.id, we see encodings for state, county, and tract, which should align with the beats we had above. Extract the 11-digit code from the GEO.id column. Add a column to the census data with the 11-digit code for each census observation.

```{r}
# add your R code here

#lets extract numbers which are after chars 'US' in geo id column using substring
census$new_11_digit_code <- substr(census$GEO.id, 10, 20)


```

##### (i) Join Datasets

Join the census data with the Beat Dataset using the 11-digit codes as keys. Be sure that you do not lose any of the police beats when doing this join (i.e. your output dataframe should have the same number of rows as the cleaned Beats Dataset - use the correct join). Are there any police beats that do not have any associated census data? If so, how many?

```{r}
# add your R code here

#lets create a left join on cleaned Beat Dataset with census data
merge_beats_census <- left_join(beats_data_updated,census,by="new_11_digit_code")


```

ans: Looking at the dataframe which is created after merging these two datasets, we can see there are no police beats which does not have any associated census data. All the police beats have associated data as we do not see any NAs.

Then, join the Crime Dataset to our joined beat/census data. We can do this using the police beat name. Again, be sure you do not lose any observations from the Crime Dataset. What is the final dimensions of the joined dataset?

```{r}
# add your R code here
merge_crime_beats_census <- left_join(crime_clean_beat,merge_beats_census,by=c("Beat"="Name"))
    

nrow(merge_crime_beats_census)
ncol(merge_crime_beats_census)
```
ans: Final Dimentions of the joined dataset :
Rows -> 347999
Columns -> 47

```{r}
#lets export this dataset as a csv file
write.csv(merge_crime_beats_census, "joined_dataset.csv")

```


Once everything is joined, save the final dataset for future use.