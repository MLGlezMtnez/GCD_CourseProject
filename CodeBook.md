# Code Book
Maykel L. González-Martínez  
20 February 2015  

----

### Synopsis

This code book describes the variables and units in the `'GCD_CP_final.txt'`
data set, a tidy data obtained as the result of the "Getting and Cleaning Data"
Course Project at Coursera.  The transformations on the original data to obtain
this data set were carried out with the `'run_analysis.R'` R script, additional
details on which can be found in `'README.md'`.

The data set is derived from the experiments by Anguita _et al._ [1], and will
only be briefly discussed here (see `'README.txt'` in `'GCD_CP_dataset.zip'`
for further details).
The experimentalists gathered several indicators from the embedded
accelerometer and gyroscope in a Samsung Galaxy S II smartphone, while a group 
of 30 volunteers performed six different activities.  3-axial linear accelerations
and 3-axial angular velocities at a constant rate of 50Hz, and the activities
manually labeled.  Butterworth filters were used to clean the signals from
gravitational sources and noise.

----

### Variables and units in `'GCD_CP_final.txt'`

`'GCD_CP_final.txt'` is a "comma separated value" (CVS) file, with 35
observations on 68 variables:

- The first column, `subject`, is of type integer (from 1 to 30---repeated
values are possible, hence the 35 observations) and indicates one of the 30
volunteers that participated in the experiment.

- The second column, `activity`, is of type character and refers to one of the
six labeled activities: walking, walking upstairs, walking downstairs, sitting,
standing and laying.

- Columns 3 to 68 are of type real, and contain the average value of mean and
standard deviation measurements per subject and activity.  The column names
refer directly to the labels used by the researchers [1] for the quantities
measured, and their specific meaning can be taken from `'features_info.txt'` in
`'GCD_CP_dataset.zip'`.  The column names are coded as follows:

    + The 't' and 'f' prefixes denote _time_ and _frequency_ domains.
    + 'Body' and 'Gravity' refer to _body_ and _gravity_ signals.
    + 'Acc' refers to _linear acceleration_.
    + 'Gyro' refers to _angular velocity_.
    + 'Jerk' denotes a _Jerk signal_.
    + 'Mag' denotes to the _Euclidean norm_ of a given 3-dimensional signal.
    + 'mean' and 'std' refer to the _mean value_ and _standard deviation_.
    + The 'X', 'Y' and 'Z' suffices are used to indicate the _x_, _y_ and _z_
    spatial directions.

All reported values are normalized to the [-1, +1] interval, hence all values
are unitless.

_Note:_ See `'features.txt'` in `'GCD_CP_dataset.zip'` for a full list of the
features measured in the experiment.

----

#### References

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
Reyes-Ortiz,
"Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly
Support Vector Machine"
_International Workshop of Ambient Assisted Living (IWAAL 2012)_.
Vitoria-Gasteiz, Spain. Dec 2012.
