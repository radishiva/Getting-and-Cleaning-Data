

## Setting the working directory
## Downloaded all files under UCIDataSet

setwd("/Users/Shiva/CleaningData/UCIDataSet")

library(reshape2)

##Loading the activity labels and features


activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation

featuresupdate <- grep(".*mean.*|.*std.*", features[,2])
featuresupdate.names <- features[featuresupdate,2]
featuresupdate.names = gsub('-mean', 'Mean', featuresupdate.names)
featuresupdate.names = gsub('-std', 'Std', featuresupdate.names)
featuresupdate.names <- gsub('[-()]', '', featuresupdate.names)


# Load the datasets

train <- read.table("X_train.txt")[featuresupdate]
trainActivities <- read.table("Y_train.txt")
trainSubjects <- read.table("subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("X_test.txt")[featuresupdate]
testActivities <- read.table("Y_test.txt")
testSubjects <- read.table("subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merging datasets and adding labels

joinData <- rbind(train, test)
colnames(joinData) <- c("subject", "activity", featuresupdate.names)

# Turn activities & subjects into factors
joinData$activity <- factor(joinData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
joinData$subject <- as.factor(joinData$subject)

joinData.melted <- melt(joinData, id = c("subject", "activity"))
joinData.mean <- dcast(joinData.melted, subject + activity ~ variable, mean)

write.table(joinData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
