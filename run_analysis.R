



library(plyr)

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileurl, destfile = "./projectdataset.zip")



unzip(zipfile = "projectdataset.zip")
      
list.files()
list.files("./UCI HAR Dataset")



# Merging the Training and Test sets into one data set


list.files("./UCI HAR Dataset/train")


# Reading the files in train folder

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")



# Reading files in test folder

list.files("./UCI HAR Dataset/test")




X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")




# Creating Feature Vector

feature_vect <- read.table("./UCI HAR Dataset/features.txt")


# Getting Labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")



#Naming Variables

colnames(X_train) <- feature_vect[,2]
colnames(Y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(X_test) <- feature_vect[,2]
colnames(Y_test) <- "activityID"
colnames(subject_test) <- "subjectID"



colnames(activity_labels) <- c("activityID", "activitytype")



#Merging data

Train_data <- cbind(Y_train,subject_train,X_train)
Test_data <- cbind(Y_test,subject_test,X_test)
Final_Data_Set <- rbind(Train_data,Test_data)


# Extracting only the Measurements on the mean and standard deviation for each measurement



col_names <- colnames(Final_Data_Set)


mean_std <- (grepl("activityID",col_names)|
               grepl("subjectID",col_names)|
               grepl("mean..",col_names)|
               grepl("std..",col_names))


subset_mean_std <- Final_Data_Set[,mean_std == TRUE]


#adding descriptive names
subset_mean_std_names <- merge(subset_mean_std,activity_labels,by = "activityID",
                               all.x = TRUE)


## all labels are added in Section Naming Variables and adding descriptive variables


#creates a second, independent tidy data set with the average of each variable for each activity and each subject.



tidySet <- aggregate(. ~subjectID + activityID, subset_mean_std_names, mean)



tidySet <- tidySet[order(tidySet$subjectID, tidySet$activityID), ]


write.table(tidySet, "tidySet.txt", row.names = FALSE)
