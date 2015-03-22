This is the codebook for tidy_data (and run_analysis.R) files. For this analysis we need dplyr, car and reshape2 packages.

1. First step was obtain the data. We can do this by download.file() and unzip(); or just manually (directly from the URL)

2. Merge the test and train groups. Step by step as we describe in run_analysis.R comments. After every command we use some general function 
    to check our results -> dim(), class(), str(), View(head(data)), View(tail(data)

    a) read the features (variable names) to a vector (later we used this vector in colnames argument by reading the X_train, and X_test)
    b) read X_train data by data.table() function (and col.names argument = features)
    c) read subject_train
    d) read Y_train
    e) Merge training group to one dataset 
    
    and repeat this procedure for test group (X_test, Y_test, subject_test)
    
    f) Merge TRAIN and TEST group to one dataset using the rbind() function

3. subset appropriate variables (ID, activity, mean\\, std\\). We can do this by grep() function (see https://stat.ethz.ch/R-manual/R-devel/library/base/html/grep.html) ; or manually

4. recode the activity variable by description in activity_labels file (we used recode() function from car package)

5. finally we compute the mean values for appropriate measurments for each subject and each activity (we used melt() and dcast() functions from reshape2 package)

I recommend and ask for my peers to check also the original UCI_HAR_Dataset files. I think in my R script in comments is everything important to understand analysis proceses.

Finally, please forget to my grammatical flaws. I'm not native speaker. 
