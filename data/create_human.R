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
