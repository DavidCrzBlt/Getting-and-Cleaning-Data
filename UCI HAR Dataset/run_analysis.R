##Getting and Cleaning data course project
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
# The goal is to prepare tidy data that can be used for later analysis.
# All the files are contained in a folder called "UCI HAR Dataset"
#First we need to install the libraries that we are going to need
library(Hmisc)
library(dplyr)
# First we must read the files that we are going to merge and indentify the data that is inside them
current_dir <- getwd()
# First I set the correct working directory to read the files
if(current_dir!="C:/Users/david/Documents/R/Coursera Module 2/UCI HAR Dataset")
{
	setwd("C:/Users/david/Documents/R/Coursera Module 2/UCI HAR Dataset")
}

#I assign column names for me to identify more easily the data on the tables

activity <- read.table("activity_labels.txt",col.names=c("Activity Number","Activity Label"))
features <- read.table("features.txt")
X_test <- read.table("./test/X_test.txt",col.names=features$V2)
X_train <- read.table("./train/X_train.txt",col.names=features$V2)
Y_test <- read.table("./test/Y_test.txt",col.names="Activity Number")
Y_train <- read.table("./train/Y_train.txt",col.names="Activity Number")
subjectTest <- read.table("./test/subject_test.txt",col.names="Subject")
subjectTrain <- read.table("./train/subject_train.txt",col.names="Subject")


#I merge the tables with their corresponding set of data
activity_test <- merge(activity,Y_test,by.x="Activity.Number",by.y="Activity.Number",all=TRUE)
activity_train <- merge(activity,Y_train,by.x="Activity.Number",by.y="Activity.Number",all=TRUE)
data_test <- cbind(X_test,activity_test,subjectTest)
data_train <- cbind(X_train,activity_train,subjectTrain)

# This is the tidy data
total_data <- arrange(rbind(data_test,data_train),"Subject","Activity.Number")

#Usar un for para el punto 5

final_data <- NULL

# 1:30 is for each subject
for(each in 1:30)
{
	# 1:6 is for every activity
	for(every in 1:6)
	{
		#I filter just the data that relates with each subject and each activity and take off the column 563 because I don't want NA's
		m <- select(filter(total_data,Subject==each,Activity.Number==every),-563)
		mean_data <- as.data.frame(lapply(m,mean))
		if (mean_data[[1]]!= "NaN")
		{
			final_data <- data.frame(rbind(final_data,mean_data))
		}
	}	
}
# Here I reincorporate the column that I took off

d <- merge(final_data,activity,by.x="Activity.Number",by.y="Activity.Number",all=TRUE)