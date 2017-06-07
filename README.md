## Getting And Cleaning Data
# Project for Getting and Cleaning Data Course on Coursera

This repository contains all the files from the UCI HAR Dataset. It also contains an R script, run_analysis.R, which takes the data from the HAR Dataset, assembles it into a single data frame and preforms downstream analysis.

Once the data is in one single data frame, the R script extracts only the data points for the mean and standard deviation of each measurement performed. This data is then labeled clearly.

Once we have made the original data tidy, we only extract the measurments for each measurment/subject/activity combo, and calculate the mean of these data points. These calculations are then written into another tidy data set and exported to tidy_data.txt
