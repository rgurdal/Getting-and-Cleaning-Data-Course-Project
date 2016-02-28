
library(plyr)


# 0. GET THE DATA
# Download and unzip the files
filename <- "getdata_dataset.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(filename)){
        download.file(fileURL, filename, method="libcurl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}
# Read the data, assigning column names
features        <- read.table("UCI HAR Dataset/features.txt") [,2]
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") [,2]
x_train         <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features)
y_train         <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
subject_train   <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
x_test          <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features)
y_test          <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
subject_test    <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")



# 1. MERGE THE TRAINING AND TEST SETS TO CREATE ONE DATA SET
# Create x, y, subject data sets
x_data        <- rbind(x_train, x_test)
y_data        <- rbind(y_train, y_test)
subject_data  <- rbind(subject_train, subject_test)



# 2. EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
# Find columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features)
# Subset the desired columns
x_data <- x_data[, mean_and_std_features]

# Bind all the data into a single data set
all_data <- cbind(x_data, y_data, subject_data)
all_data$Subject  <- factor(all_data$Subject)
all_data$Activity <- activity_labels[all_data$Activity]


# 3. USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
# 4. APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
# (Done as data read into R, Step 0 above)


# 5. CREATE A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH 
# VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
averages_data <- ddply(all_data, .(Subject, Activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
cat('Summary dataset written to "averages_data.txt".')  

