# Noora Sheridan 8.2.2017. In this file I am doing analysis on a dataset "Student alcohol consumption" available here: https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

# Reading the datasets into R from my local folder
student_mat <- read.csv("/Users/Noora/Documents/IODS-project/data/student-mat.csv", sep = ";", header = TRUE)
student_por <- read.csv("/Users/Noora/Documents/IODS-project/data/student-por.csv", sep = ";", header = TRUE)

# Exploring the structure and dimensions of the data, first for math dataset, then for Portuguese
str(student_mat)
dim(student_mat)
# The math dataset has 395 observations and 33 variables (e.g. school, sex, age)

str(student_por)
dim(student_por)
# The Portuguese dataset has 649 observations and 33 variables (like the math one)

# Joining the two datasets
library(dplyr)
identifier_columns <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery", "internet")
matpor <-inner_join(student_mat, student_por, by = identifier_columns, suffix = c(".math", ".por"))

# Exploring the structure and dimensions of the joined dataset matpor
str(matpor)
dim(matpor)
# The dataset has now 382 observations and 53 variables. The column names end either .por or .math to indicate which dataset the columns originally belonged to. The identifier columns have no suffixes, however.

# Combining the duplicated answers
# First a new dataframe 'alc' is created with originally just the identifier_columns
alc <- select(matpor, one_of(identifier_columns))

# Then all duplicate columns (i.e. all but identifier_columns) are chosen
duplicate_columns <- colnames(student_mat)[!colnames(student_mat) %in% identifier_columns]
# For every column name in duplicate columns, select two columns from 'matpor' with the same original name, and select the first column vector of the two columns
for(column_name in duplicate_columns) {
  two_col <- select(matpor, starts_with(column_name))
  first_col <- select(two_col, 1)[[1]]
  
  # if the first column vector is numeric: take a rounded average of each row in the two columns, and add the resulting vector to the alc data frame
  if(is.numeric(first_col)) {
    alc[column_name] <- round(rowMeans(two_col))
    
    # if not numeric: add the first column vector to the alc data frame
  } else {
    alc[column_name] <- first_col
  }
}

# Next new column alc_use is created to 'alc' by taking the averages of the answers related to weekday & weekend alcohol consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
# Another new column, high_use is created to show those whose alcohol consumption in alc_use is greater than 2 (shown as true) or lower (shown as false)
alc <- mutate(alc, high_use = alc_use > 2)

# Next a glimpse of 'alc' is taken
glimpse(alc)

# It can be seen from the output that 'alc' has 382 observation and 35 variables, as expected.

# Saving the dataset to my local data folder
write.table(alc, file = "/Users/Noora/Documents/IODS-project/data/create_alc.txt")
