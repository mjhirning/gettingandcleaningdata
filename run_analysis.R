# This code was written for the Getting and Cleaning Data course on Coursera. It takes in the data from UCI Machine Learning on Smart Phone 
# information and cleans it for analysis. This code assumes that all of the data has been stored in the current working directory.

# 1. Step 1 is to merge the two data sets into one data set. The data and labels for each set come in three different .txt files 
# which will need to be read in. The subject info contains the data of the perosn in the study. The labels contain the data of the activity they were
# doing. The set is the information contains the set of measurements that were collected for each subject/activity combination. 

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
labels <- rbind(train_labels, test_labels)
set <- rbind(train_set, test_set)
subject <- rbind(train_subject, test_subject)
data <- cbind(subject, labels, set)

# 2. Step 2 is to extract only the information on the mean and standard deviation of each measurements. Using the data in the features.txt file, we can extract
# the columns that correspond to the mean and standard dev. for each data type. Using this information we can filter out all other information.

features <- read.table("./UCI HAR Dataset/features.txt")                            
logic <- grepl("mean()",features$V2)|grepl("std()",features$V2)                    
features <- features[logic,]
logic2 <- grepl("Freq", features$V2)
features <- features[!logic2,]
col <- features$V1 
col <- c(1, 2, col+2)
data <- data[,col]

# 3. Step 3 is naming the activity labels with clear descriptive labels

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities[,2] <- tolower(activities[,2])
activities[,2] <- gsub("_", " ", activities[,2])
colnames(activities) = c("number", "activity") 
data <- merge(activities, data, by.x = "number", by.y = "V1.1")
n <- ncol(data) 
data <- data[,2:n]


# 4. Step 4 is appropriately labeling the data set with descriptive names

data_names <- as.character(features$V2)
data_names <- gsub("tBody","Time Domain Body ",data_names)
data_names <- gsub("fBody","Frequency Domain Body ",data_names)
data_names <- gsub("tGravity","Time Domain Gravity ",data_names)
data_names <- gsub("fGravity","Frequency Domain Gravity ",data_names)
data_names <- gsub("Acc"," Accelerometer ",data_names)
data_names <- gsub("Gyro"," Gyroscope ",data_names)
data_names <- gsub("Jerk","Jerk ",data_names)
data_names <- gsub("Mag","Magnitude",data_names)
data_names <- gsub("-mean","Mean",data_names)
data_names <- gsub("-std","Standard Deviation",data_names)
colnames(data) <- c( "activity", "subject", data_names)
write.csv(data, "./data.csv")

# 5. Step 5 is creating a new data set, from the data set in step 4, which contains the data for the average for each activity and each subject
rows <- c(1)
tidy_data <- matrix(1,68)

walking <- data[data$activity %in% c("walking"),]
for (i in 1:30){
  walking2 <- walking[walking$subject %in% c(i),]
  walking3 <- data.matrix(walking2)
  l <- ncol(walking3)
  walking4 <- walking3[,3:l]
  walking_add <- colMeans(walking4)
  walking_add <- c("walking", i, walking_add)
  tidy_data <- cbind(tidy_data, walking_add)
}

walkingup <- data[data$activity %in% c("walking upstairs"),]
for(i in 1:30){
  walkingup2 <- walkingup[walkingup$subject %in% c(i),]
  walkingup3 <- data.matrix(walkingup2)
  l <- ncol(walkingup3)
  walkingup4 <- walkingup3[,3:l]
  walkingup_add <- colMeans(walkingup4)
  walkingup_add <- c("walking upstairs", i, walkingup_add)
  tidy_data <- cbind(tidy_data, walkingup_add)
}

walkingdown <- data[data$activity %in% c("walking downstairs"),]
for(i in 1:30){
  walkingdown2 <- walkingdown[walkingdown$subject %in% c(i),]
  walkingdown3 <- data.matrix(walkingdown2)
  l <- ncol(walkingdown3)
  walkingdown4 <- walkingdown3[,3:l]
  walkingdown_add <- colMeans(walkingdown4)
  walkingdown_add <- c("walking downstairs", i, walkingdown_add)
  tidy_data <- cbind(tidy_data, walkingdown_add)
}

sitting <- data[data$activity %in% c("sitting"),]
for(i in 1:30){
  sitting2 <- sitting[sitting$subject %in% c(i),]
  sitting3 <- data.matrix(sitting2)
  l <- ncol(sitting3)
  sitting4 <- sitting3[,3:l]
  sitting_add <- colMeans(sitting4)
  sitting_add <- c("sitting", i, sitting_add)
  tidy_data <- cbind(tidy_data, sitting_add)
}

standing <- data[data$activity %in% c("standing"),]
for(i in 1:30){
  standing2 <- standing[standing$subject %in% c(i),]
  standing3 <- data.matrix(standing2)
  l <- ncol(standing3)
  standing4 <- standing3[,3:l]
  standing_add <- colMeans(standing4)
  standing_add <- c("standing", i, standing_add)
  tidy_data <- cbind(tidy_data, standing_add)
}

laying <- data[data$activity %in% c("laying"),]
for(i in 1:30){
  laying2 <- laying[laying$subject %in% c(i),]
  laying3 <- data.matrix(laying2)
  l <- ncol(laying3)
  laying4 <- laying3[,3:l]
  laying_add <- colMeans(laying4)
  laying_add <- c("laying", i, laying_add)
  tidy_data <- cbind(tidy_data, laying_add)
}

tidy_data <- t(tidy_data)
tidy_data <- tidy_data[2:181,]
colnames(tidy_data)[1] <- "Activity"
colnames(tidy_data)[2] <- "Subject"
rownames(tidy_data) <- 1:180
write.csv(tidy_data, "./tidy_data.csv")

# Fin