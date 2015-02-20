# README.md
Maykel L. González-Martínez  
20 February 2015  

----

This repository contains the solution to the "Getting and Cleaning Data" Course Project at Coursera.

----

#### The repository includes the following files:

- 'README.md': This file.
- 'run_analysis.R': An R script that loads, preprocesses and analyses the data given for the Course Project; its end result is the tidy data set ('GCD_CP_final.txt').
- 'CodeBook.md': The code book for the Course Project final data set ('GCD_CP_final.txt') with all the variables and summaries calculated, including units, etc.
- 'GCD_CP_final.txt': The tidy data set created for the Course Project.
- 'GCD_CP_dataset.zip': The original data for the project.

----

#### Details on the analysis with 'run_analysis.R'



_Note_: Details on the data, and the contents of all files were obtained from
`'README.txt'`, provided with the data for the project.

The script starts by checking that the necessary data files are in the working
directory, and downloads and/or extracts them if necessary.

```r
# (if necessary) downloads and/or extracts the data files
if(!("UCI HAR Dataset" %in% dir())) {
    fzip_Name <- "GCD_CP_dataset.zip"
    if(!(file.exists(fzip_Name))) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile = fzipName, method = "curl",
                      mode = "wb")
    }
    unzip(fzip_Name)
}
```

Then, both the training and test data sets are read in, and joined together into
the `all` data frame.

```r
# 1. Merges the training and the test sets to create one data set
train.set <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE,
                        colClasses = "numeric")
test.set <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE,
                       colClasses = "numeric")
all <- rbind(train.set, test.set)
rm(train.set, test.set)
```

The next step is to select only the measurements containing information on
means and standard deviations---the code book used to specify the desired
columns is the complete list of features in `'features.txt'`.

```r
# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE,
                       colClasses = c("numeric", "character"),
                       col.names = c("id", "feat"))
all <- all[, grep("(mean\\(\\)|std\\(\\))", features$feat)]
```

The training and test activity labels are then loaded, joined and attached to
`all`.  The actual activity names are obtained from the
`'activity_labels.txt'` code book.  The `all` and `ActLab` (coding the activity
labels) data frames are then merged to add descriptive activity names into
`all`.

```r
# 3. Uses descriptive activity names to name the activities in the data set
train.ActLab <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE,
                           colClasses = "integer", col.names = "ALabel")
test.ActLab <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE,
                          colClasses = "integer", col.names = "ALabel")
all <- cbind(rbind(train.ActLab, test.ActLab), all)
ActLab <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE,
                     colClasses = c("integer", "character"),
                     col.names = c("ALabel", "activity"))
ActLab$activity <- gsub("_", " ", tolower(ActLab$activity))
all <- merge(x = ActLab, y = all, by = "ALabel")
all <- all[-1]
rm(train.ActLab, test.ActLab, ActLab)
```

Descriptive labels for the rest of the columns are obtained directly from the
`features` data frame (which holds the code book in `'features.txt'`).

```r
# 4. Appropriately labels the data set with descriptive variable names
ids <- as.numeric(sub("V", "", names(all[2:ncol(all)])))
colnames(all)[2:ncol(all)] <- gsub("\\(\\)", "", features$feat[ids])
rm(features, ids)
```

Finally, a `subject` column is added with the subject labels from the training
and test data.  A new (`final`) data frame is created from `all`, using the
`group_by()` and `summarise_each()` functions from the `dplyr` library to find
averages for each measurement column, per subject and activity.  The `final`
data frame contains a tidy data set (of the _wide_ form)---the main goal
of the Course Project---which is printed to `'GCD_CP_final.txt'` in a CVS
format.

```r
# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
train.SubLab <- read.table("UCI HAR Dataset/train/subject_train.txt",
                           header = FALSE, colClasses = "integer",
                           col.names = "subject")
test.SubLab <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           header = FALSE, colClasses = "integer",
                           col.names = "subject")
all <- cbind(rbind(train.SubLab, test.SubLab), all)
rm(train.SubLab, test.SubLab)
# final step, using dplyr
library(dplyr)
final <- group_by(all, subject, activity) %>%
    summarise_each(funs(mean))
write.table(final, "GCD_CP_final.txt", sep = ",", row.names = FALSE)
```

The script finalizes by cleaing the workspace.

```r
# cleans up the workspace
detach("package:dplyr", unload = TRUE)
rm(all, final)
```
