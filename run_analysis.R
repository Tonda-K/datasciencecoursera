# required packages dplyr, car, reshape2

## First of all, we want to download and unzip particular files
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")
unzip(Dataset.zip)
list.files() ## check 
## or we can do it manually. Obviously you have to set your working directory 

## 1. Step ## ## 1. Step ## ## 1. Step ## 

#### read features to vector, later we can use to colnames 
features <- read.table("./UCI_HAR_Dataset/features.txt")
head(features) ## check

# set the features as a vector 
features <- as.vector(features$V2)
head(features) ## check
class(features)## check

#### read X_train, colnames features ####
X_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt", col.names = features)

## check the X_train <start>
View(head(X_train, n=3)) 
dim(X_train)
str(X_train)
## check the X_train <end>

#### read subject_train ####
subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")
dim(subject_train) # check

#### read Y_train ####
Y_train <- read.table("./UCI_HAR_Dataset/train/Y_train.txt")

## check the Y_train <start>
dim(Y_train)
str(Y_train)
## check the Y_train <end>

#### Merge training group to one dataset ####
TRAIN <- cbind(Y_train, X_train ); TRAIN <- rename(TRAIN, activity = V1)
TRAIN <- cbind(subject_train, TRAIN); TRAIN <- rename(TRAIN, ID = V1)

## check the TRAIN <start>
View(head(TRAIN, n=3)) 
dim(TRAIN)
str(TRAIN)
## check the TRAIN <end>

##################################

#### read X_test ####
X_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt", col.names = features)

## check the X_test <start>
View(head(X_test, n=3)) 
dim(X_test)
str(X_test)
## check the X_test <end>

#### read subject_test ####
subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")
dim(subject_test) # check

#### read Y_test ####
Y_test <- read.table("./UCI_HAR_Dataset/test/Y_test.txt")

## check the Y_test <start>
dim(Y_test)
str(Y_test)
## check the Y_test <end>

#### Merge testing group to one dataset ####
TEST <- cbind(Y_test, X_test ); TEST <- rename(TEST, activity = V1)
TEST <- cbind(subject_test, TEST); TEST <- rename(TEST, ID = V1)

## check the TEST <start>
View(head(TEST, n=3)) 
dim(TEST)
str(TEST)
## check the TEST <end>

######################

### Merge TRAIN and TEST group to one dataset

dataset <- rbind(TRAIN, TEST)

## check the dataset <start>
View(head(dataset, n=3)) 
dim(dataset)
str(dataset)
## check the dataset <end>

## Step 2 ## ## Step 2 ## ## Step 2 ## 
View(colnames(dataset))

## subset appropriate variables (ID, activity, mean\\, std\\) 
subs_data <- select(dataset, ID:tBodyAcc.std...Z, tGravityAcc.mean...X:tGravityAcc.std...Z,
                tBodyAccJerk.mean...X:tBodyAccJerk.std...Z, tBodyGyro.mean...X:tBodyGyro.std...Z,
                tBodyGyroJerk.mean...X:tBodyGyroJerk.std...Z, tBodyAccMag.mean.., tBodyAccMag.std..,
                tGravityAccMag.mean.., tGravityAccMag.std.., tBodyAccJerkMag.mean.., tBodyAccJerkMag.std..,
                tBodyGyroMag.mean.., tBodyGyroMag.std.., tBodyGyroJerkMag.mean.., tBodyGyroJerkMag.std..,
                fBodyAcc.mean...X:fBodyAcc.std...Z, fBodyAcc.meanFreq...X:fBodyAcc.meanFreq...Z, fBodyAccJerk.mean...X:fBodyAccJerk.std...Z, 
                fBodyAccJerk.meanFreq...X:fBodyAccJerk.meanFreq...Z, fBodyGyro.mean...X:fBodyGyro.std...Z, fBodyGyro.meanFreq...X:fBodyGyro.meanFreq...Z, fBodyAccMag.mean.., fBodyAccMag.std.., fBodyAccMag.meanFreq.., fBodyBodyAccJerkMag.mean..,
                fBodyBodyAccJerkMag.std.., fBodyBodyAccJerkMag.meanFreq.., fBodyBodyGyroMag.mean.., fBodyBodyGyroMag.std..,fBodyBodyGyroMag.meanFreq..,
                fBodyBodyGyroJerkMag.mean.., fBodyBodyGyroJerkMag.std.., fBodyBodyGyroJerkMag.meanFreq.., angle.tBodyAccMean.gravity.:angle.Z.gravityMean.)


## check subs_data <start>
View(head(subs_data, n=3)) 
dim(subs_data)
x <- colnames(subs_data); sum(duplicated(x))
## check subs_data <end>

## Step 3 ## ## Step 3 ## ## Step 3 ## ## Step 3 ##
subs_data$activity <- recode(subs_data$activity, "1 = 'WALKING'; 2 = 'WALKING_UPSTAIRS'; 3 = 'WALKING_DOWNSTAIRS'; 4 = 'SITTING'; 5 = 'STANDING'; 6 = 'LAYING'", as.factor.result=T)

## check subs_data <start>
View(head(subs_data, n=3)) 
View(tail(subs_data, n=3)) 
class(subs_data$activity)
## check subs_data <end>

## Step 4 -> is already done ## 

## Step 5 ## ## Step 5 ## ## Step 5 ## 

## Final dataset = DF
## melt subseted data to DF by ID and activity
DF <- melt(subs_data, id.vars=c("ID" , "activity"))

## check subs_data <start>
View(head(DF, n=3)) 
View(tail(DF, n=3))
## check subs_data <end>

## Finally, use dcast function, with arg fun mean to get the final result (mean values 
## of measurment for each subject and each activity)
RESULT <- dcast(DF, ID + activity ~ variable, fun.aggregate = mean,
                na.rm=TRUE)
dim(RESULT)
View(RESULT)

##
file.create("tidy_data")
write.table(RESULT, file = "tidy_data.txt", sep = " ", row.name=FALSE)
