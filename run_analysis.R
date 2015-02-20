#===============================================================================
# author: Maykel L. Gonzalez-Martinez             date (last update): 20/02/2015
# status: finished, tested
#----------------------------- general information -----------------------------
# Course Project in "Getting and Cleaning Data" at Coursera.
#===============================================================================
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

# 1. Merges the training and the test sets to create one data set
train.set <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE,
                        colClasses = "numeric")
test.set <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE,
                       colClasses = "numeric")
all <- rbind(train.set, test.set)
rm(train.set, test.set)

# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE,
                       colClasses = c("numeric", "character"),
                       col.names = c("id", "feat"))
all <- all[, grep("(mean\\(\\)|std\\(\\))", features$feat)]

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

# 4. Appropriately labels the data set with descriptive variable names
ids <- as.numeric(sub("V", "", names(all[2:ncol(all)])))
colnames(all)[2:ncol(all)] <- gsub("\\(\\)", "", features$feat[ids])
rm(features, ids)

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

# cleans up the workspace
detach("package:dplyr", unload = TRUE)
rm(all, final)