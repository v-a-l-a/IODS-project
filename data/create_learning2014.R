# Noora Sheridan, 26.01.2017. This file includes exercises for the second week of the IODS course.

# EXERCISE 2
# Reading the data into R
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Exploring the structure of the data in learning2014
str(learning2014)
#The output shows that the data frame has 60 columns (variables) and 183 rows (observations). Most of the data is integers, except for column gender which has two levels, female or male (shown as either value 1 or value 2 in the observations). All the column names and first observations for each column are also shown.

# Exploring the dimensions of the data in learning2014
dim(learning2014)
# This shows just the number of rows (183) and of columns (60).

# EXERCISE 3
# Creating the analysis dataset.
# Let's access dplyr library so we can use select function. (If dplyr not installed should first be installed)
library(dplyr)

# Let's first exclude students with 0 points
learning2014 <- filter(learning2014, learning2014$Points > 0)

# Combining questions relating to deep to create deep_questions
deep_questions <- c("D03", "D11", "D19", "D27", "D07","D14", "D22", "D30", "D06", "D15", "D23", "D31")
# Selecting the columns related to deep learning
deep_columns <- select(learning2014, one_of(deep_questions))
# Next we want the average of deep-related questions
learning2014$deep <- rowMeans(deep_columns)

# We repeat the above steps completed with deep for stra and surf
stra_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")
stra_columns <- select(learning2014, one_of(stra_questions))
learning2014$stra <- rowMeans(stra_columns)

surf_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21", "SU29", "SU08", "SU16", "SU24", "SU32")
surf_columns <- select(learning2014, one_of(surf_questions))
learning2014$surf <- rowMeans(surf_columns)

# We want to convert the combination variable attitude to 1-5 scale (as in DataCamp), by dividing each number in the Attitude vector by 10. We save these results as attitude (non-capital A).
learning2014$attitude <- learning2014$Attitude / 10

# Next we create the dataset with 7 variables (columns) gender, age, attitude, deep, stra, surf, points. We first choose to keep these columns.
keep_columns <- c("gender", "Age", "attitude", "deep", "stra", "surf", "Points")
# Now we create a new dataset AnalysisSet with just these columns.
AnalysisSet <- select(learning2014, one_of(keep_columns))

# We double check that the dataset AnalysisSet is correct by finding out how many columns and rows it has. It should have 166 rows (observations) and 7 columns (variables).
dim(AnalysisSet)
# The output shows that we have 166 rows and 7 columns as expected.

# As extra practice, we now rename the columns so that all columns start with a non-capital letter.
colnames(AnalysisSet)[2] <- "age"
colnames(AnalysisSet)[7] <- "points"

# EXERCISE 4
# Set the working directory of this session to be the IODS-project folder
setwd("~/Documents/IODS-project")

# Saving the analysis dataset to the data folder
write.table(AnalysisSet, file = "/Users/Noora/Documents/IODS-project/data/learning2014.txt")

# Demonstrating that we can read the data again.
read.table("/Users/Noora/Documents/IODS-project/data/learning2014.txt")

# Checking the structure of the data is correct
str(read.table("/Users/Noora/Documents/IODS-project/data/learning2014.txt"))
# The output shows the dataset has 166 observations and 7 variables. Columns shown are: gender, age, attitude, deep, stra, surf, points. Thus table seems correct. Interesting to note that now some columns' data type is numeric instead of integer.

# Checking the first 6 observations in the dataset.
head(read.table("/Users/Noora/Documents/IODS-project/data/learning2014.txt"))
# Again we see that the dataset has 7 columns. The values of observations are correct when comparing with AnalysisSet's first 6 observations.

# We conclude that the dataset has been successfully saved to the data folder and can be read again!