
 
#download and unzip
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(fileurl,'./UCIHARDataset.zip', mode = 'wb')
  unzip("UCIHARDataset.zip", exdir = getwd())


#reading data from the files

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity", "activityname"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")

# Merges the training and the test sets to create one data set.
data_train<-cbind(subject_train, y_train, x_train)
data_test<-cbind(subject_test, y_test, x_test)
data<- rbind(data_train, data_test)
rm(subject_train, y_train, x_train,subject_test, y_test, x_test,data_train, data_test)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
data_cleaned <- data %>% select(subject, activity, contains("mean"), contains("std"))
rm(data)
# Uses descriptive activity names to name the activities in the data set
data_cleaned$activity <- activities[data_cleaned$activity, 2]

#  Appropriately labels the data set with descriptive variable names.
colheads <- names(data_cleaned)
colheads <- gsub("[(][)]", "", colheads)
colheads <- gsub("^t", "Time_", colheads)
colheads <- gsub("^f", "Frequency_", colheads)
colheads <- gsub("Acc", "Accelerometer", colheads)
colheads <- gsub("Gyro", "Gyroscope", colheads)
colheads <- gsub("Mag", "Magnitude", colheads)
colheads <- gsub("-mean-", "_Mean_", colheads)
colheads <- gsub("-std-", "_StandardDeviation_", colheads)
colheads <- gsub("-", "_", colheads)
names(data_cleaned) <- colheads
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
FinalData <- data_cleaned %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
