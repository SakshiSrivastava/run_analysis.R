## Begin
install.packages("data.table")
library("data.table")

#1. Merges the training and the test sets to create one data set.

## Training Data Set

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

## Feature and Activity Lables

features <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## Test Data Set

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

##Using rbind and cbind to combine the data

dataset_subject <- rbind(subject_train, subject_test)
dataset_Y <- rbind(y_train, y_test)
dataset_X <- rbind(X_train, X_test)
names(dataset_subject) <- c("subject")
names(dataset_X) <- features$V2
names(dataset_Y) <- c("activity")
merge_dataset <- cbind(dataset_subject, dataset_Y)
Dataset <- cbind(dataset_X, merge_dataset)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 

Data <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
get_Names <- c(as.character(Data), "subject", "activity")
Dataset <- subset(Dataset, select=get_Names)

##3. Uses descriptive activity names to name the activities in the data set

Dataset$activity <- factor(Dataset$activity, labels=activityLabels$V2)

##4. Appropriately labels the data set with descriptive variable names. 
names(Dataset) <- gsub("^t", "time", names(Dataset))
names(Dataset) <- gsub("^f", "frequency", names(Dataset))
names(Dataset) <- gsub("Acc", "Accelerometer", names(Dataset))
names(Dataset) <- gsub("Gyro", "Gyroscope", names(Dataset))
names(Dataset) <- gsub("Mag", "Magnitude", names(Dataset))
names(Dataset) <- gsub("BodyBody", "Body", names(Dataset))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##loading plyr to aggregate

library(plyr)

tidyData <- aggregate(.~subject + activity, Dataset, mean)

##this creates a dataset that is ordered 1:30 for each activity
##Arranging the data by Subject

tidyData <- tidyData[order(tidyData$subject, tidyData$activity),]

## writing the data in a text file in your local system

write.table(tidyData, file = "tidyData.txt", row.name=FALSE)
## End