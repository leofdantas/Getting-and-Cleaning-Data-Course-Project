library(dplyr)

# Load files
## Test Data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "subject"

### X-test
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
#### Add feature names to x_test variables
features <- read.table("UCI HAR Dataset/features.txt")
features <- features[,2]
names(x_test) <- features

### Y-test
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
#### Add exercise type names to Y_test variables
names(y_test) <- "type_exercise"
y_test[y_test == 1] <- "walking"
y_test[y_test == 2] <- "walking_upstairs"
y_test[y_test == 3] <- "walking_downstairs"
y_test[y_test == 4] <- "sitting"
y_test[y_test == 5] <- "standing"
y_test[y_test == 6] <- "laying"

## Combine y_test and x_test to subjects
test <- cbind(y_test, x_test)
test <- cbind(subject_test, test)

## Train Data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(subject_train) <- "subject"

### X-train
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
#### Add feature names to x_train variables
features <- read.table("UCI HAR Dataset/features.txt")
features <- features[,2]
names(x_train) <- features

### Y-train
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
#### Add exercise type names to Y_train variables
names(y_train) <- "type_exercise"
y_train[y_train == 1] <- "walking"
y_train[y_train == 2] <- "walking_upstairs"
y_train[y_train == 3] <- "walking_downstairs"
y_train[y_train == 4] <- "sitting"
y_train[y_train == 5] <- "standing"
y_train[y_train == 6] <- "laying"

## Combine y_train and x_train to subjects
train <- cbind(y_train, x_train)
train <- cbind(subject_train, train)

# Merging the training and the test sets to create one data set.
merged <- rbind(test, train)


# Extracting only the measurements on the mean and standard deviation for each measurement. 
std_mean_columns <- grep("mean|std", names(merged))
merged_short <- merged[,c(1,2,std_mean_columns)]

# Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
run_var_mean <- merged_short %>%
  group_by(subject, type_exercise) %>%
  summarize_all(funs(mean))

write.csv(run_var_mean, "run_var_mean.csv", row.names = FALSE)
