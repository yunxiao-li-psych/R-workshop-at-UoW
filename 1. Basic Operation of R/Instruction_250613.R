library(tidyverse) 
library(readxl)
# 1. form good habits
## 1.1 hash tag here is to add comments, always add comments when you write codes

## 1.2 build your studio interface (see slides)

## 1.3 set working directory
## [method 1] see slides 
## [method 2] customize yours
## setwd("//mokey.ads.warwick.ac.uk/Desktop/Warwick Document/R workshop_250613")

## 1.4 choose packages (list all the packages at the top or your codes)
install.packages('tidyverse') # put package name in quotes
library(tidyverse) # include 
library(readxl) # read excel document
help('library') # seek help
?library # seek help

# 2. create variables & data frame
## 2.1 single variable vs multiple variables
x <- 3
y <- 4
z <- x + y
z
class(z) # check variable attributes

a <- 'height' # use quote to create character variable
class(a)

b <- 3 > 4 #variable b stores logical value
b
class(b)

c <- c(3,4,NA) # use 'c()' to create multiple variables
d1 <- c*x
d1

d2 <- mean(c)
d2
d2 <- mean(c,na.rm  = TRUE) # remove NA
d2

d3 <- log(c) # no need to say na.rm = TRUE
d3

#check about their description to find out more
?log() 
?mean()

## 2.2 create data frame (column by column)
## don't forget giving a name to your variables/data frames
physical <- data.frame(
  ID = c('S01', 'S02','S03'),
  Gender = c('Female', 'Male','Male'),
  Weight_KG = c(56,78,67),
  Height_M = c(1.6, 1.9,1.75))

View(physical)

head(physical) #list the first several rows of your data frame

class(physical$ID) # use $ to access specific column
class(physical$Weight_KG)# note:be careful the name your write here
# is the same as in the data frame, such as 'capital letter'

class(physical$Gender)

levels(physical$Gender) # prepare for data analysis
# make it into categorical variable

physical$Gender <- as.factor(physical$Gender) #some models automatically create dummy variables for each level of the factor

class(physical$Gender)
levels(physical$Gender) #the first one is the reference level

# you can relevel it
physical$Gender <- relevel(physical$Gender, ref = "Male")
levels(physical$Gender)

# how to change row names and column names
colnames(physical) <- c('ID','Gender','Weight','Height')
View(physical)
colnames(physical)[1] <- 'Subject' # change single column name
View(physical)

# how to add a column?
physical$PEscore <- c(85,90,78)
View(physical)

# how to add a row?
new_row <- data.frame(
  Subject = c('S04','S05'),
  Gender = c('Male','Male'),
  Weight = c(NA,47),
  Height = c(1.7,1.65),
  PEscore = c(65,88)
)

physical_new_row <- rbind(physical, new_row)
View(physical_new_row)

#------------------------ Task 1----------------------
#------------------------ Task 1----------------------

# 3. basic data transformation 
## read csv file (read 'my_physical_data.csv')
my_physical_data <- read.csv('my_physical_data.csv')
View(my_physical_data)

## read .xlsx file (read 'physical_data.xlsx')
read_physical_xlsx <- read_xlsx('physical_data.xlsx')
View(read_physical_xlsx)

## 3.1 select column/row (remove height)
## Select the first four rows and all columns except the fourth
physical_select <- my_physical_data [c(1:4),c(1,2,3,5)]
View(physical_select)

## 3.2 only show male data (filter data based on conidtion)
physical_male <- filter(physical_select, Gender == 'Male')
View(physical_male)


## 3.3 deal with NA

## check whether cells have NAs 
is.na(physical_male)
is.na(physical_male$Weight) 

which(is.na(physical_male$Weight)) # you know which row has a NA,
## You can locate the NA values and then replace or remove it.

# check which row has NAs
complete.cases(physical_male) 
which(!complete.cases(physical_male)) # know which row has NAs
# note that '!' means negation

View(physical_male)
physical_male[3,3] <- 70
View(physical_male)

## 3.4 long format and wider format
physical_male_long <- gather(physical_male, key = 'Dimension', value = 'Measurement','Weight','PEscore')
View(physical_male_long)

physical_male_wide <- spread(physical_male_long, key = 'Dimension', value = 'Measurement')
View(Physical_male_wide)

## 3.5 Export the dataset as a CSV file
write.csv(physical_male_long, 'physical_male_long.csv',row.names = FALSE) ## prevents writing row numbers as a separate column (optional but common)

#-------------------------------Task 2-------------------------------
#-------------------------------Task 2-------------------------------

# 4.advanced data transformation
## use 'psych_data' again
View(psych_data)

## Calculate the mean RT for accurate Task 1 by gender
## use %>% to make the code clean
## %>% (pipe operator) helps keep the result of the right hand

psych_mean_RT <- psych_data%>%
  filter(Accuracy_Task1 == 1)%>%
  group_by(Gender)%>%
  summarize(mean_RT = mean(RT_Task1, na.rm = TRUE))
View(psych_mean_RT)
