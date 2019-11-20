#After downloading the .zip file and unzipping it, you see there is a README.txt file, features.txt file, features_info.txt file 
#and activity_labels.txt file.  There are also two folders: test and train.Within these folders are additional folders and files 
# containing test and training data sets.  After reading the README file and looking through the folders, it looks like the 
# working data we need is training data set (x and y) test data set (x and y) features, and the activity labels.  None of the 
#text files have lables so these have to be created (assignment question number 3).


#start by reading the different tables
# read the test tables
xtest = read.table("X_test.txt",header = FALSE)
ytest = read.table("y_test.txt",header = FALSE)
subject_test = read.table("subject_test.txt",header = FALSE)

#Read the training tables
xtrain = read.table("X_train.txt",header = FALSE)
ytrain = read.table("y_train.txt",header = FALSE)
subject_train = read.table("subject_train.txt",header = FALSE)

#.Read the features data
features = read.table("features.txt",header = FALSE)
#Read activity labels data
activityLabels = read.table("activity_labels.txt",header = FALSE)


#Now we need to add column names to the data, I'm starting with the test data sets (x, y, and subject)
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

#and to the train data (x,y, and subject)
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#now we should be able to merge the train and test datasets to create one data set (Assignment objective #1), first by merging all the 
#test data, then all the training data, then the train and test together.
merge_test = cbind(ytest, subject_test, xtest)
merge_train = cbind(ytrain, subject_train, xtrain)

#Create the main data table merging both table tables - this is the outcome of 1
masterdataset = rbind(merge_train, merge_test)


# New dataset is now called masterdataset, look at names
colNames = colnames(masterdataset)
colNames
#Extract measurements on the mean and standard deviations for each measurement (Assignment objective #2).
meanstd = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#And subset this out, new subset is called meanandstd.
meanandstd <- masterdataset[ , meanstd == TRUE]

#Use descriptive activity names to name the activiiteis in the dataset (Assignment objective #3)
activitynames = merge(meanandstd, activityLabels, by='activityId', all.x=TRUE)

# New tidy set has to be created (calling it myTidySet)
myTidySet <- aggregate(. ~subjectId + activityId, activitynames, mean)
myTidySet <- myTidySet[order(myTidySet$subjectId, myTidySet$activityId),]

#The last step is to write the ouput to a text file 
write.table(myTidySet, "myTidySet.txt", row.name=FALSE)
#now a .txt file should be located in your working directory called myTidySet.txt...I hope it worked for you :)
