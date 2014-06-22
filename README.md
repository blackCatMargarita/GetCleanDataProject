### Assumptions

This createTidyData function assumes that is located in the UCI HAR Dataset directory containing the the following text files:

* activity_label.txt
* features.txt
* run_analysis.R

This function also assumes the UCI HAR Directory contains the following subdirectories and text files:

* train/subject_train.txt
* train/X_train.txt
* train/y_train.txt
* test/subject_test.txt
* test/X_test.txt
* test/y_test.txt

### How to run createTidyData()

This function does not take any input arguments. All the data required for creating the tidy data is assumed to be in the folder structure described above.

The following steps will produce the tidy data:
    
    setwd("~/UCI HAR Dataset")
    source("run_Analysis.R")
    data <- createTidyData()

Note that the parent directory name shown as "UCI HAR Dataset" can be any name as long as it contains the structure described above. 

The returned data set will contain means of each of the measurement variables that had labels containing mean() or std().  The measurement means are provided for each valid combination of activity and subject.  Combinations of activity and subject that did not produce a valid measurement mean were dropped from the tidy set.

CodeBook.md describes how this function works in more detail.
