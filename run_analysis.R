# Packages: reshape2 is being used to calculate the averages of the features
require(reshape2)

ReadSubjects <- function() {
    # Reads the train + test subject values
    # Returns data frame containing Subject
    
    train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject"))
    test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject"))
    rbind(test, train)
}

ReadFeatureLabels <- function() {
    # Reads feature labels into data frame, and calculates extra fields for visibility and a formatted name for the result
    # Returns data frame containing Id, Name, Visible, FormattedName
    
    featureLabels <- read.table("./UCI HAR Dataset/features.txt", col.names = c("Id", "Name"), stringsAsFactor = FALSE)
    featureLabels$Visible <- grepl("-(std|mean)\\(\\)", featureLabels$Name)
    
    v <- gsub("^t", "Time", featureLabels$Name)
    v <- gsub("^f", "Frequency", v)
    v <- gsub("Acc", "Acceleration", v)
    v <- gsub("Gyro", "Gyroscope", v)
    v <- gsub("Mag", "Magnitude", v)
    v <- gsub("mean", "Mean", v)
    v <- gsub("std", "StandardDeviation", v)
    v <- gsub("[\\(\\)-]", "", v)
    featureLabels$FormattedName <- v
    
    featureLabels
}

ReadFeatures <- function() {
    # Reads the train + test feature values and filters the visible features
    # Returns data frame containing all Visible feature values
    
    featureLabels <- ReadFeatureLabels()
    
    train <- read.table("./UCI HAR Dataset/train/x_train.txt", col.names = featureLabels$FormattedName)
    test <- read.table("./UCI HAR Dataset/test/x_test.txt", col.names = featureLabels$FormattedName)
    features <- rbind(test, train)
    
    features[ ,featureLabels$Visible]
}

ReadActivities <- function() {
    # Reads the train + test activities and transforms them to the appropriate readable text
    # Returns an array containing the readable text

    activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Id", "Name"))

    train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("Id"))
    test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("Id"))
    activities <- rbind(test, train)
    
    sapply(activities$Id, function(a) { activityLabels$Name[activityLabels$Id == a]})
}

CalculateAverages <- function(dataset) {
    # Computes the average per Subject + Activity for all variables for the given dataset
    # Returns data frame containing Subject, Activity and average per variable
    
    dsmelt <- melt(dataset, id = c("Subject", "Activity"))
    averages <- dcast(dsmelt, Subject + Activity ~ variable, mean)
    
    # Alter the names to append 'Mean' to the end of the column names
    names(averages) <- c(n[c(1,2)], paste(n[seq(3,length(n))], "Mean", sep=""))
    
    averages
}

if(!file.exists("./UCI HAR Dataset")) {
    
    if(!file.exists("./source.zip")) {
        print("Downloading datafile")
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile = "./source.zip")
    }
    
    print("Extracting datafile")
    unzip("./source.zip", exdir = "./")
}


print("Reading data")

subjects <- ReadSubjects()
features <- ReadFeatures()
activities <- ReadActivities()

dataset <- cbind(Subject = subjects, Activity = activities, features)

print("Calculating averages")
datasetMean <- CalculateAverages(dataset)

print("Writing data files")
write.table(dataset, file="dataset.txt", row.names = FALSE)
write.table(datasetMean, file="dataset_mean.txt", row.names = FALSE)

print("Done")