library(dplyr)

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#4)label data using variable names
colnames(X_train) <- features[,2]
colnames(X_test) <- features[,2]

colnames(Y_train) <- "activityid"
colnames(Y_test) <- "activityid"

colnames(subject_train) <- "subjectid"
colnames(subject_test) <- "subjectid"

colnames(activity_labels) <- c("activityid","activity")

#1)merged data to create one data set
mtrain <- cbind(Y_train,subject_train,X_train)
mtest <- cbind(Y_test,subject_test,X_test)
data <- rbind(mtrain,mtest)

#2)set having mean and standard deviation
mean_std <- data[grepl("mean",colnames(data))|grepl("std",colnames(data))]
mean_std <- cbind(data$activityid,data$subjectid,mean_std) 
colnames(mean_std)[1:2] <- c("activityid","subjectid")

#3)set activity names as column names
labeledset <- merge(activity_labels,mean_std,by="activityid",all.x = TRUE)

#5)independent tidy data set with the average of each variable for 
#each activity and each subject
tidydata <- select(labeledset,c(1,-2,3:82))
tidydata <- aggregate(. ~subjectid+activityid,data=tidydata,mean)
tidydata <- merge(activity_labels,tidydata,by="activityid")

write.table(tidydata,"tidydata.txt",row.name=FALSE)