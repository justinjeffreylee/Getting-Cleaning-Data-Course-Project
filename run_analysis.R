## Load Test files
subject_test <- read.table("test/subject_test.txt", stringsAsFactors=FALSE, 
                           sep="", header=FALSE)
x_test <- read.table("test/X_test.txt", stringsAsFactors=FALSE, 
                     sep="", header=FALSE)
y_test <- read.table("test/Y_test.txt", stringsAsFactors=FALSE, 
                               sep="", header=FALSE)

## Load Train files
subject_train <- read.table("train/subject_train.txt", stringsAsFactors=FALSE, 
                           sep="", header=FALSE)
x_train <- read.table("train/X_train.txt", stringsAsFactors=FALSE, 
                     sep="", header=FALSE)
y_train <- read.table("train/Y_train.txt", stringsAsFactors=FALSE, 
                     sep="", header=FALSE)

## Load Features List
features <- read.csv("features.txt", stringsAsFactors=FALSE,
                     header=FALSE, sep="")


## Set Column names in x_test and x_train
colnames(x_test) <- features[,2]
colnames(x_train) <- features[,2]
colnames(subject_test) <- "Subject"
colnames(subject_train) <- "Subject"
colnames(y_test) <- "Activity"
colnames(y_train) <- "Activity"

## Bind Test & Train data sets
x_test <- cbind(subject_test, y_test, x_test)
x_train <- cbind(subject_train, y_train, x_train)

com_data <- rbind(x_test, x_train)

## Convert Activity # to Text
com_data[,2] <- gsub(1, "Walking", com_data[,2])
com_data[,2] <- gsub(2, "Walking_Upstairs", com_data[,2])
com_data[,2] <- gsub(3, "Walking_Downstairs", com_data[,2])
com_data[,2] <- gsub(4, "Sitting", com_data[,2])
com_data[,2] <- gsub(5, "Standing", com_data[,2])
com_data[,2] <- gsub(6, "Laying", com_data[,2])

## Extract columns with Mean or Std
extract <- com_data[,grep(paste(c("std","mean"),collapse="|"), 
                      colnames(com_data), value=TRUE )]
extract <- cbind(com_data[,1:2], extract)

## Clean up Variable Names
colnames(extract) <- gsub("-", "", colnames(extract))
colnames(extract) <- gsub("mean", "Mean", colnames(extract))
colnames(extract) <- gsub("freq", "Freq", colnames(extract))
colnames(extract) <- gsub("std", "Std", colnames(extract))
colnames(extract) <- gsub("X", "AxisX", colnames(extract))
colnames(extract) <- gsub("Y", "AxisY", colnames(extract))
colnames(extract) <- gsub("Z", "AxisZ", colnames(extract))

## Reshape Data 
library(reshape2)
extractMelt <- melt(extract, id=c("Subject", "Activity"), 
                    measure.var=3:81)
Final_Results <- dcast(extractMelt, Subject + Activity ~ 
                               variable,mean)

## Export Final Results
write.table(Final_Results, file="Final_Results", sep=" ", row.names=FALSE)









