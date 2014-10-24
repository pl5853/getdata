### Cleaning data

This repository contains the scripts to retrieve and tidy the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The analysis can be executed by running the run\_analysis.R file. The [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is expected to be unzipped in the workspace, otherwise it will automatically be downloaded and extracted. 

The script writes the tidy data in the following files:

- dataset.txt: This file contains the mean and standard deviation features of all the observations
- dataset_mean.txt: This file contains per Subject and Activity the average value of the mean and standard deviation features

More information about these files can be found in the [CodeBook](CodeBook.md).