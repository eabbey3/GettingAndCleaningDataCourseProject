
##Getting and Cleaning Data Course Project

#run_analysis.R(This Script) an R script that does the following.
        
# Data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

######################################################################################################


# set working directory to root

setwd('~')

# Download the data from provided url and put the file in the data folder

if(!file.exists("./data")){dir.create("./data")}
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataUrl,destfile="./data/Dataset.zip")


# Unzip data file to data directory

unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Set working dir to unziped file

setwd('~/data/UCI HAR Dataset/')


# 1. Merges the training and the test sets to create one data set.
#------------------------------------------------------------------

# Read data from files
datafeatures     <- read.table('features.txt', header = FALSE)
dataActivityType <- read.table('activity_labels.txt', header = FALSE)
dataSubjectTrain <- read.table('train/subject_train.txt', header = FALSE)
dataXTrain       <- read.table('train/x_train.txt', header = FALSE)
dataYTrain       <- read.table('train/y_train.txt', header = FALSE)

# Set column names to the data imported above
colnames(dataActivityType)  <- c('activityId','activityType')
colnames(dataSubjectTrain)  <- "subjectId"
colnames(dataXTrain)        <- datafeatures[,2]
colnames(dataYTrain)        <- "activityId"

# Set finaTtrainData by merging dataSubjectTrain, dataXTrain and dataYTrain
trainData <- cbind(dataSubjectTrain,dataXTrain,dataYTrain)

# Read from test data (subject_test.txt, x_test.txt, y_test.txt)
dataSubjectTest <- read.table('test/subject_test.txt', header = FALSE)
dataXTest       <- read.table('test/x_test.txt', header = FALSE)
dataYTest       <- read.table('test/y_test.txt', header = FALSE)

# Set column names to the test data imported above
colnames(dataSubjectTest) <- "subjectId"
colnames(dataXTest)       <- datafeatures[,2]
colnames(dataYTest)       <- "activityId"

# Create the final test set by merging the xTest, yTest and subjectTest data
testData <- cbind(dataSubjectTest,dataXTest,dataYTest)

# Combine both training and test data to create the final data set
finalData <- rbind(trainData,testData)

# Create a vector for the column names from the finalData
dataColNames  <- colnames(finalData)



# 2. Extract only the measurements on the mean and standard deviation for each measurement
#-----------------------------------------------------------------------------------------
# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector <- (grepl("activity..",dataColNames) 
                  | grepl("subject..",dataColNames) 
                  | grepl("-mean..",dataColNames) 
                  & !grepl("-meanFreq..",dataColNames) 
                  & !grepl("mean..-",dataColNames) 
                  | grepl("-std..",dataColNames) 
                  & !grepl("-std()..-",dataColNames));

# Subset finalData table based on the logicalVector to keep only desired columns
finalData <- finalData[logicalVector==TRUE]


# 3. Use descriptive activity names to name the activities in the data set
#-------------------------------------------------------------------------
# Merge the finalData set with the dataAcitivityType table to include descriptive activity names
finalData <- merge(finalData,dataActivityType,by='activityId',all.x=TRUE)

# Updating the colNames vector to include the new column names after merge
dataColNames  <- colnames(finalData)


# 4. Appropriately label the data set with descriptive activity names
#--------------------------------------------------------------------
# Clean up the variable names
for (i in 1:length(dataColNames)) {
        dataColNames[i] = gsub("\\()","",dataColNames[i])
        dataColNames[i] = gsub("-std$","StdDev",dataColNames[i])
        dataColNames[i] = gsub("-mean","Mean",dataColNames[i])
        dataColNames[i] = gsub("^(t)","time",dataColNames[i])
        dataColNames[i] = gsub("^(f)","freq",dataColNames[i])
        dataColNames[i] = gsub("([Gg]ravity)","Gravity",dataColNames[i])
        dataColNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",dataColNames[i])
        dataColNames[i] = gsub("JerkMag","JerkMagnitude",dataColNames[i])
        dataColNames[i] = gsub("GyroMag","GyroMagnitude",dataColNames[i])        
        dataColNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",dataColNames[i])
        dataColNames[i] = gsub("[Gg]yro","Gyro",dataColNames[i])
        dataColNames[i] = gsub("AccMag","AccMagnitude",dataColNames[i])
}

# Assigning the new descriptive column names to the finalData set
colnames(finalData) <- dataColNames


# 5.From data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
#-------------------------------------------------------------------------------------------
# Create a new table, DataWithNoActivityType without the activityType column
DataWithNoActivityType <- finalData[,names(finalData) != 'activityType']

# Summarizing the DataWithNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData   <- aggregate(DataWithNoActivityType[,names(DataWithNoActivityType) != c('activityId','subjectId')],
                        by=list(activityId=DataWithNoActivityType$activityId,subjectId = DataWithNoActivityType$subjectId),mean)

# Merg the tidyData with dataActivityType to include descriptive acitvity names
tidyData   <- merge(tidyData,dataActivityType,by='activityId',all.x=TRUE)

# Export the tidyData to file
write.table(tidyData, './tidyData.txt',row.names = TRUE,sep = '\t')

