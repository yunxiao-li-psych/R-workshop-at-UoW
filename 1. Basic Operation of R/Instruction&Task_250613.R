# 1. form good habits
## 1.1 build your studio interface (see slides)

## 1.2 set working directory
## [method 1] see slides 
## [method 2] customize yours
## setwd("//mokey.ads.warwick.ac.uk/Desktop/Warwick Document/R workshop_250613")

## 1.3 choose packages (list all the packages at the top or your codes)
install.packages('tidyverse')
library(tidyverse) # include 
library(readxl) # read excel document
help("library") # seek help
?library # seek help

# 2. create variables & dataframe
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
physical <- data.frame(
  ID = c('S01', 'S02','S03'),
  Gender = c('Female', 'Male','Male'),
  Weight_KG = c(56,78,67),
  Height_M = c(1.6, 1.9,1.75))

View(physical)

head(physical) #list the first several rows of your data frame

class(physical$ID)
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

#------------------------ Task 1 Start----------------------
## 1.Create a data frame like this, name it ‘task_1’
task_1 <- data.frame(
  Subject = c('S01', 'S02','S03'),
  Familiarity_scale5 = c(3,2,5),
  Accuracy = c(1,0,0),
  ReactionTime_ms = c(500,200,NA))
View(task_1)

## 2.Change the name of column 2 to Familiarity
## 3.Change the name of column 4 to RT
colnames(task_1)[2] <- 'Familiarity'
colnames(task_1)[4] <- 'RT'
colnames(task_1) <- c('Subject','Familiarity','Accuracy','RT')
View(task_1)

## 4. Add a new column showing the logarithm of RT
# you can use round()function to set the number of decimal places
task_1$log_RT <- round(log(task_1$RT),2) 
View(task_1)
#------------------------ Task 1 Ending----------------------

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
View(physical_male_wide)

## 3.5 Export the dataset as a CSV file
write.csv(physical_male_long, "physical_male_long.csv",row.names = FALSE) ## prevents writing row numbers as a separate column (optional but common)

#---------------------------Task 2 Start----------------------
## 1
psych_data <- read.csv('psych_data.csv')
View(psych_data)

## 2
psych_data_Task_1 <- psych_data[,-c(3,7,9)] # this is a new way to select column,'-'means 'exclusion/negation'
## alternative: psych_data_Task_1 <- psych_data_female[,c(1:6,8)] # this is a new way to select column,'-'means 'exclusion/negation'
View(psych_data_Task_1)

## 3
psych_data_accuracy <- filter(psych_data_Task_1, psych_data_Task_1$Accuracy_Task1 == 1)
view(psych_data_accuracy)

## 4
complete.cases(psych_data_accuracy) # there are NAs
which(!complete.cases(psych_data_accuracy))# locate rows
psych_data_Task_1_complete <- psych_data_accuracy[-c(12:14,16,22,24,31),]
View(psych_data_Task_1_complete)

## 5
psych_data_Task_1_long <- gather(psych_data_Task_1_complete, key = 'Wellbeing', value = 'Score', 'Anxiety_Score','Depression_Score')
View(psych_data_Task_1_long)

## 6
psych_data_order <- psych_data_Task_1_long[,c(1,2,5,6,3)]
View(psych_data_order)
#-------------------------------Task 2 Ending-------------------------------

# 4.advanced data transformation
## use 'psych_data' again
View(psych_data)

## Calculate the mean RT for Task 1 by gender
## use %>% to make the code clean
## %>% (pipe operator) helps keep the result of the right hand

psych_mean_RT <- psych_data%>%
  filter(Accuracy_Task1==1)%>%
  group_by(Gender)%>%
  summarize(mean_RT = mean(RT_Task1, na.rm = TRUE))
View(psych_mean_RT)

#---------------Task 3 Start----------------------
psych_data <- read.csv('psych_data.csv')
View(psych_data)

Anxiety_data_summary <- psych_data%>%
  filter(Accuracy_Task1 == 1 & Anxiety_Score >15)%>%
  group_by(Gender)%>%
  summarize(mean_RT_Task1 = mean(RT_Task1, na.rm = TRUE),
            mean_RT_Task2 = mean(RT_Task2, na.rm = TRUE))
View(Anxiety_data_summary)
#------------------Task 3 Ending--------------------------


