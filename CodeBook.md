# Code Book
Maykel L. González-Martínez  
19 February 2015  

> <!-- <span style="color:darkgrey">Observation: Please, note that inline R code is
                             shown within parentheses.</span> -->

## Loading and preprocessing the data
I start by loading the `knitr`,  `dplyr` and `ggplot2` packages,

```r
# loads required packages
require(knitr)
require(dplyr)
require(ggplot2)
```
and load the data in `activity.csv` into a _tbl_ object called `tbl.activity`
(having previously unzipped the `activity.zip` file if necessary).

```r
# checks if 'activity.csv' is in the working directory; otherwise, gets it from 'activity.zip'
#if(!file.exists("activity.csv")) unzip("activity.zip")
# loads the data into tbl.activity
#tbl.activity <- tbl_df(read.csv("activity.csv"))
```
