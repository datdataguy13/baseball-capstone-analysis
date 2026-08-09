# rm(list = ls())
library(Lahman)
library(tidyverse)
data(Fielding)
# Data exmaple 
#Fielding %>%
#  subset(playerID == "molinya01") %>%
#  select(-WP, -ZR)
myInfieldData <- Fielding

# Let's look at only the Major league level in the past 20 years
myRecentInfieldData<- filter(myInfieldData, yearID > 1998)

myALFieldData <- filter(myRecentInfieldData, lgID == "AL")

myNLFieldData <- filter(myRecentInfieldData, lgID == "NL")

# Take data from AL and NL for all MLB data during this time
myFieldData <- union(myALFieldData,myNLFieldData)

# Let's keet the anlysis very specific to erros and errors that extend to every field not just specific ones like the pitcher and catcher
#  

myDataSlimmed <-
myFieldData %>%
 select(-WP,-ZR,-playerID,-teamID,-PB,-SB,-stint,-CS)

# Remove NAs
na.omit(myDataSlimmed)

# Create Numbering for position players

myDataSlimmed$POS[myDataSlimmed$POS == "P"] <- 1
myDataSlimmed$POS[myDataSlimmed$POS == "C"] <- 2
myDataSlimmed$POS[myDataSlimmed$POS == "1B"] <- 3
myDataSlimmed$POS[myDataSlimmed$POS == "2B"] <- 4
myDataSlimmed$POS[myDataSlimmed$POS == "3B"] <- 5
myDataSlimmed$POS[myDataSlimmed$POS == "SS"] <- 6
myDataSlimmed$POS[myDataSlimmed$POS == "OF"] <- 7

# Let's convert it from a character to a number
myDataSlimmed$POS <- as.numeric(as.character(myDataSlimmed$POS))

myDataSlimmed

# The data looks good lets create a clean name for it

myDataClean <- myDataSlimmed 

# write_csv(myDataSlimmed,"MyTestDataFielding.csv")

# myDataClean <- read_csv("MyTestDataFieldingClean.csv")

# Errors on average by position, let's round to the fullest number to determine if a player is more error proned our not
myAvgErrorData <-
myDataClean %>%
  group_by(POS)%>%
  summarise(average = mean(E))

myAvgErrorData <-
  myAvgErrorData %>%
  rename(
    AvgErrors = average
  )


# This was a fun case statement to create a derived column
myDataClean$ErrorInd <- ifelse(myDataClean$POS == 1 & myDataClean$E > 1 | myDataClean$POS == 2 & myDataClean$E > 3 | myDataClean$POS == 5 & myDataClean$E > 4 | myDataClean$POS == 3 & myDataClean$E > 2 |  myDataClean$POS == 4 & myDataClean$E > 3 | myDataClean$POS == 6 & myDataClean$E > 5 | myDataClean$POS == 7 & myDataClean$E > 1, 1 ,0) 
myDataClean

# Let's see if we can make a training data set and test data set to see if we can predict errors by positions

set.seed(1234)
head(myDataClean)
# logistic regression approach
# building out sample
smp_size <- floor(0.7*nrow(myDataClean))
# creating training and test sets
train_ind <- sample(seq_len(nrow(myDataClean)),size = smp_size)
train <- myDataClean[train_ind,]
test <- myDataClean[-train_ind,]
# run regression model This is not working email professor with code and file and see what we can do
fit_log_new <- glm(ErrorInd ~ POS+G+A+DP+lgID+yearID, data=train,family=binomial)
summary(fit_log_new)
1-pchisq(26528,25286)
# under .05
1-pchisq(15843,25280) # VERY LARGE!!! It is plausible that the data emminate from a logistic regression model that includes a constant term and the 4 constant terms


# The rest is supplemental analysis and I liked my regression model analysis enough to not include the rest in my final paper.

# Let's run a linear discriminat Model

#head(myDataClean)

#set.seed(456)

#Train <- myDataClean$ErrorInd %>% createDataPartition(p=0.8, list=FALSE)
#training <- myDataClean[Train, ]
#testing <- myDataClean[-Train, ]

#preproc.param <- training %>% preProcess(method=c("center", "scale"))
#training.trans <- preproc.param %>% predict(training)
#testing.trans <- preproc.param %>% predict(testing)

#model <- lda(ErrorInd~., data=training.trans)
#predictions <- model %>% predict(testing.trans)
#mean(predictions$class == testing$ErrorInd)

# Decision Trees
#output_tree <- ctree(ErrorInd ~ POS+G+A+DP+lgID+yearID,data=train)
#plot(output_tree)  # Plot the tree.
#pred_ot <-predict(output_tree,newdata=test)
# Not very descriptive at first sight, let's try random forest to see if we get something more descriptive

# Random Forests
#error_forest <- cforest(ErrorInd ~ POS+G+A+DP+lgID+yearID,data=train)
#varimp(error_forest)
# Get notes on what these mean
#pred <- predict(error_forest, newdata=test)
#pred

#table(pred)
#table(pred, predict > 0.5)

# This is my data all summarized, all fielding position broken out by totals

#myFieldData <- myCurrentInFieldData %>%
  #select(-WP,-ZR,-playerID,-teamID,-PB,-SB,-stint,-yearID,-lgID)

#myFieldData %>% group_by(POS) %>% summarize_all(sum)