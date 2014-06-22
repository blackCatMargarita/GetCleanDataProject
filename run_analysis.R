 createTidyData <- function(){
## 1. Merges the training and the test sets to create one data set.

# load associated feature names
# (creates table with two columns where names are in second column)
features <- read.table("features.txt")
# replace certain characters
features[,2] <- sapply(features[,2],function(x) gsub("-","",x))
#features[,2] <- sapply(features[,2],function(x) gsub("\\(","",x))
#features[,2] <- sapply(features[,2],function(x) gsub("\\)","",x))
features[,2] <- sapply(features[,2],function(x) gsub(",","_",x))

# load train feature vector
trainData <- read.table("train/X_train.txt")
# label train data with feature names
names(trainData) <- features[,2]

# load test feature vector
testData <- read.table("test/X_test.txt")
# label test data with feature names
names(testData) <- features[,2]

# Now merge train and test data into same data frame
data <- rbind(trainData,testData)


## 2. Extracts only the measurements on the mean and standard deviation 
##    for each measurement. 

meanColNames <- grep("mean\\(\\)", features[,2])
stdColNames <- grep("std\\(\\)", features[,2])
## create data matrix with the columns
dataMeanStd <- cbind(data[,meanColNames],data[,stdColNames])

## create data frame that also includes activitis and subjects with dataMeanStd
## which will be used for next steps of project

# load train subject data
trainSubject <- read.table("train/subject_train.txt",col.names="subject")
# combine subject data with train data 
#trainData <- cbind(trainSubject,trainData)
# load train label data (class numbers corresponding to activities)
trainLabel <- read.table("train/y_train.txt",col.names="activity")
# combine label data with train data 
#trainData <- cbind(trainLabel, trainData)

# load test subject data
testSubject <- read.table("test/subject_test.txt",col.names="subject")
# combine subject data to test data 
#testData <- cbind(testSubject,testData)
testLabel <- read.table("test/y_test.txt",col.names="activity")
# combine label data with test data 
#testData <- cbind(testLabel, testData)

labels <- rbind(trainLabel,testLabel)
subjects <- rbind(trainSubject,testSubject)

dataShort <- cbind(labels, subjects, dataMeanStd)

## 3. Uses descriptive activity names to name the activities in the data set

## read in table of activity labels and description
activityDescriptions <- read.table("activity_labels.txt",col.names = c("num","text"))
## replace number values with activity text descriptions 
trainActivityLabels <- merge(trainLabel,activityDescriptions,by.x = "activity",by.y="num",all.x=TRUE)
testActivityLabels <- merge(testLabel,activityDescriptions,by.x = "activity",by.y="num",all.x=TRUE)
newActivityLabels <-rbind(trainActivityLabels,testActivityLabels)
dataShort$activity <- newActivityLabels$text

## 4. Appropriately labels the data set with descriptive variable names. 

# data set was labeled with descriptive variable names before merging (see above)

## 5. Creates a second, independent tidy data set with the average of each 
##    variable for each activity and each subject. 
library()
nVars <- length(names(dataShort))
vars <- names(dataShort)
dataMelt <- melt(dataShort,id=c("activity","subject"), measure.vars=vars[3:nVars])
tidyData <- dcast(dataMelt,activity + subject ~ variable, mean)
tidyData
}
## Some other possible combinations not used
# dataTidyAct <- dcast(dataMelt,activity ~ variable, mean)
# colnames(dataTidyAct)[1] <- "variable"
# dataTidySub <- dcast(dataMelt,subject ~ variable, mean)
# colnames(dataTidySub)[1] <- "variable"
# dataTidyCombo <- rbind(dataTidyAct,dataTidySub)
# 
# MeanBySubj <- sapply(split(dataShort,dataShort$subject), function(x) colMeans(x[,3:nVars]))
# MeanByAct <- sapply(split(dataShort,dataShort$activity), function(x) colMeans(x[,3:nVars]))