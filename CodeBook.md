### Method for createTidyData <- function()

#### Merge the training and the test sets to create one data set.
The function first loads feature names for the measurement data. This creates a table with two columns where names are in second column.
        features <- read.table("features.txt")

Next, the function removes character "-" and ",":
        features[,2] <- sapply(features[,2],function(x) gsub("-","",x))
        features[,2] <- sapply(features[,2],function(x) gsub(",","_",x))

Next, the function loads training feature data and applies the feature names as column headings.  The same is done for the test feature data:
        trainData <- read.table("train/X_train.txt")
        names(trainData) <- features[,2]
        testData <- read.table("test/X_test.txt")
        names(testData) <- features[,2]

The function then merges training and test data into the same data frame using an rbind:
        data <- rbind(trainData,testData)

#### Extract only the measurements on the mean and standard deviation for each measurement. 

The function uses a grep on "mean()" and "std()" to locate the columns of interest. A more narrow data set is generated based on these columns and is called dataMeanStd:

        meanColNames <- grep("mean\\(\\)", features[,2])
        stdColNames <- grep("std\\(\\)", features[,2])        
        dataMeanStd <- cbind(data[,meanColNames],data[,stdColNames])

The following code reads in the activity and subject data for both the training and test data.  It creates a column for each variable type and then adds these two columns to dataMeanStd. 

        trainSubject <- read.table("train/subject_train.txt",col.names="subject")
        trainLabel <- read.table("train/y_train.txt",col.names="activity")
        testSubject <- read.table("test/subject_test.txt",col.names="subject")
        testLabel <- read.table("test/y_test.txt",col.names="activity")
        labels <- rbind(trainLabel,testLabel)
        subjects <- rbind(trainSubject,testSubject)
        dataShort <- cbind(labels, subjects, dataMeanStd)

#### Use descriptive activity names to name the activities in the data set

The following code reads in the activity labels and replaces the numeric values in the data with the textual descriptions.  The key function utilized is merge where the parameters include an all.x=TRUE.
        activityDescriptions <- read.table("activity_labels.txt",col.names = c("num","text"))
        trainActivityLabels <- merge(trainLabel,activityDescriptions,by.x = "activity",by.y="num",all.x=TRUE)
        testActivityLabels <- merge(testLabel,activityDescriptions,by.x = "activity",by.y="num",all.x=TRUE)
        newActivityLabels <-rbind(trainActivityLabels,testActivityLabels)
        dataShort$activity <- newActivityLabels$text

#### Descriptive variable names were added to the data by using the features data from features.txt. 

#### Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

Finally, this function performs a data melt so that each meausrement is a variables and activity and subject are captured in their own columns, which results in a long narrow column (4 columns). The dcast function performs the final step to create the tidy data of mean measurements for each combination of activity and subject:

        nVars <- length(names(dataShort))
        vars <- names(dataShort)
        dataMelt <- melt(dataShort,id=c("activity","subject"), measure.vars=vars[3:nVars])
        tidyData <- dcast(dataMelt,activity + subject ~ variable, mean)
        tidyData
    

