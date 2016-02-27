## Getting and Cleaning Data Project



### Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


### Attribute Information:

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


##### A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


### Process 1. Merges the training and the test sets to create one data set
Listed files below are loaded into tables frames, after which colomns are renamed and data merged.
features.txt, activity_labels.txt, subject_train.txt, x_train.txt, y_train.txt, subject_test.txt, x_test.txt, y_test.txt.


### Process 2. Extracts only the measurements on the mean and standard deviation for each measurement
Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others.
Subset finalData table based on the logicalVector to keep only desired columns.


### Process 3. Uses descriptive activity names to name the activities in the data set
Merge the finalData set with the dataAcitivityType table to include descriptive activity names.
Updating the colNames vector to include the new column names after merge.
 

### Process 4. Appropriately labels the data set with descriptive variable names
Cleanup and assigning the new descriptive column names to the finalData set.


### Process 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Create a new table, DataWithNoActivityType without the activityType column.
Summarizing the DataWithNoActivityType table to include just the mean of each variable for each activity and each subject.
Merg the tidyData with dataActivityType to include descriptive acitvity names.
Export the tidyData to file.

