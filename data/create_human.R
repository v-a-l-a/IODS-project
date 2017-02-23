# Name: Noora Sheridan
# In this file I continue working on the dataset that was wrangled in exercise 4. Below is the part that I completed in exercise 4 and this week's part starts from row 55.

# Reading the datasets into R and naming them hd and gii
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F, sep = ",")
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..", sep = ",")

# Exploring the structure and dimensions of hd:
str(hd)
dim(hd)
# There seems to be 195 observations and 8 variables in this dataset

# Exploring the structure and dimensions of gii:
str(gii)
dim(gii)
# There seems to be 195 observations and 10 variables in this dataset

# Summary of the variables in hd:
summary(hd)

# Summary of the variables in gii:
summary(gii)

# Renaming variables in hd:
colnames(hd)[1:8] <- c("HDI_r", "Country", "HDI", "Life_exp", "Educ_exp", "Educ_mean", "GNI", "GNI-HDI")
# Checking that this worked
str(hd)
# Seems correct

# Renaming variables in gii:
colnames(gii)[1:10] <- c("GII_r", "Country", "GII", "Mat_deaths", "Young_births", "Parl_seats", "High_educ_f", "High_educ_m", "F_working", "M_working")
# Double checking
str(gii)
# Is correct again

# Mutating gii, adding the ratio of female and male populations with secondary education as new variable High_educ_f_m
library(dplyr)
gii <- mutate(gii, High_educ_f_m = High_educ_f / High_educ_m)

# Mutating gii to add the second new variable (the ratio of labour force participation of females and males), F_m_working
gii <- mutate(gii, F_m_working = F_working / M_working)

# Checking that this worked
str(gii)
# Both variables were succesfully added to my dataset gii

# Joining the two datasets using the variable country as identifier (keeping only the countries in both datasets):
human <- inner_join(hd, gii, by = "Country")

# Saving the new human dataset to my local folder
write.table(human, file = "/Users/Noora/Documents/IODS-project/data/create_human.txt")



# Here starts the part relating to exercise 5!

# First removing the thousands separator "," (i.e. all commas) from GNI column, and saving the data as numeric and naming the column GNI_ for now
library(stringr)
GNI_ <- str_replace(human$GNI, pattern = ",", replace = "") %>% as.numeric

# Next mutating the data by adding the numeric GNI_ variable (not removing the original non-numeric GNI variable for now as in next step I choose to only keep some columns)
human <- mutate(human, GNI_)

# Next I choose to only keep specific columns (the column names in my file are different from those in the meta file)
keep <- c("Country", "High_educ_f_m", "F_m_working", "Educ_exp", "Life_exp", "GNI_", "Mat_deaths", "Young_births", "Parl_seats")
human <- select(human, one_of(keep))

# Next I remove all rows with missing values by using the complete.cases function and rename my dataset as human_
human_ <- filter(human, complete.cases(human) == TRUE)

# Next I use tail() to look at the last 10 observations in the human_dataset to see which of them are not about countries
tail(human_, n = 10)
# From the output I see that the last 7 observations relate to regions and should be removed

# Next I define the last observation I want to keep and choose everything until this last kept observation (Niger)
last <- nrow(human_) - 7
human_ <- human_[1:last, ]
# Checking that Niger is the last kept observation:
tail(human_, n = 1)
# It is, thus removing observations relating to regions was successful!

# Defining the row names by the country names and removing the country name column
rownames(human_) <- human_$Country
human_ <- select(human_, -Country)

# Checking that the data has 155 observations and 9 variables:
dim(human_)
# The output shows that I have correctly 155 observations. The output says that I have 8 variables, but as the row names now note the variable Country I do have 9 variables

# Saving the human_ data in my local data folder (but with name creare_human_.txt)
write.table(human_, file = "/Users/Noora/Documents/IODS-project/data/create_human_.txt", row.names = TRUE)
