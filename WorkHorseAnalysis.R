# come up with a cool graph that shows average games played by position
library(Lahman)
library(tidyverse)
library(caret)
library(e1071)
library(party)
library(FactoMineR)
library(factoextra)
library(mlbench)
library(elasticnet)
data(Fielding)
data(Batting)
data(People)

myPlayers <- People
myPositionData <- Fielding
myPositionData <- filter(myPositionData, yearID > 1998)

myPositionPlayer <- myPositionData %>%
  select(yearID,POS,playerID,G) %>%
  filter(POS != 'P')

summary(myPositionPlayer$G)

myavgGames <- myPositionPlayer %>% 
                group_by(playerID,yearID) %>% 
                summarise(G = sum(G)) 
         
myavgGamesByPos <- myPositionPlayer %>% 
  group_by(playerID,yearID,POS) %>% 
  summarise(G = sum(G)) 

# Let's get a visual of average of games played by each position

myavgGamesByPosViz <- myPositionPlayer %>% 
  group_by(POS) %>% 
  summarise(G = mean(G))

# I like this visual, let's get one more looking at our workhorses
ggplot(myavgGamesByPosViz, aes(x=factor(POS), y=G)) + stat_summary(fun.y="mean", geom="bar")

# Let's get primary position data by each player
myPlayerPrimaryPosition <- myavgGamesByPos %>%
  group_by(playerID,yearID) %>%
  filter(G == max(G)) %>%
  arrange(playerID,yearID,POS)

# Let's see if we can make Yadi our primary Catcher position
myPlayerPrimaryPosition %>%
  subset(playerID == "molinya01")

# And it worked! Let's find out on average how many games a player plays
mycleanPrimaryData <- myPlayerPrimaryPosition %>%
                        select(playerID,yearID,POS)

#40.82563 games average games played by a player # WOW did not expect that, let's see if we can do better and say double that 
myavgGames %>%
subset(playerID == "molinya01")

# WH stands for work horse and is seeing if a player in a year played close to double the average of games played for a year
myavgGames$WH <- ifelse(myavgGames$G > 79, 1,0)

myavgGames
# Merge data with player birthday, to eventually determin player age in a season

myPlayerGames <- merge(myavgGames,People, by="playerID")

head(myPlayerGames)

myPlayerAge <- myPlayerGames  %>%
  select(playerID,yearID,G,WH,birthYear) 
  
myPlayerAge$age <- myPlayerAge$yearID - myPlayerAge$birthYear

myPlayerAge
myPlayerAge <- myPlayerAge  %>%
  select(playerID,yearID,G,WH,age) 

# 12419
myPlayerAge
# 12541
mycleanPrimaryData

# mydatasets are two different sizes and I don't like that and I need to join on two conditions, it's time to make a super column in both that concatentates playerID and Year
myPlayerAge$yearPlayer <- paste(myPlayerAge$playerID,myPlayerAge$yearID)
head(myPlayerAge)

mycleanPrimaryData$yearPlayer <- paste(mycleanPrimaryData$playerID,mycleanPrimaryData$yearID)
head(myPlayerAge)

myCombinedData <- merge(x = mycleanPrimaryData, y = myPlayerAge, by = "yearPlayer", all.x = TRUE)

myData1 <- myCombinedData %>%
  select(playerID.x,yearID.x,POS,G,WH,age)

# Cleaning up the Alias column name issue
myData1 <-
myData1 %>%
  rename(
     yearID = yearID.x,
     playerID = playerID.x 
  )

# Let's pull over a few more factors - errors, hits, rbis - then we should have enough data to run some PCA analysis
# Start with Batting Data
myBattingData <- Batting
myBattingData <- filter(myBattingData, yearID > 1998)

head(myBattingData)

myTestBattingData <- 
                      myBattingData %>%
                        select(playerID,yearID,H,R,SB,RBI,BB,SO) 

## Yes!!!! The data matches baseball reference, need to include errors and this should be good to go to add the final data set
myTestBattingData %>%
  subset(playerID == "molinya01")

myTestBattingData$playerYear <-paste(myTestBattingData$playerID,myTestBattingData$yearID)

myTestBattingDataClean <-

myTestBattingData %>%
  select(playerID,yearID,playerYear,H,R,SB,RBI,BB,SO)

# 23894 rows
myTestBattingDataClean 

myFieldData <-
myPositionData %>%
  select(playerID,yearID,A,E,DP)

# Let's check our data and see how it looks

myFieldData %>%
  subset(playerID == "molinya01")

# So, we have data broken out by position again, for this analysis I want the total of every position and their primary position is how they player will be evaluated
myFieldDataSummarized <-

myFieldData %>%
  group_by(playerID,yearID) %>%
  summarise(A=sum(A),E=sum(E),DP=sum(DP))

# Time to Check Again
myFieldDataSummarized %>%
  subset(playerID == "molinya01")

# Much Better! Let's create another good join condition for the batting and fielding data to go together with

myFieldDataSummarized$playerYear <-paste(myFieldDataSummarized$playerID,myFieldDataSummarized$yearID)

# Let's combine this with the Batting data before we add it into our final data set for PCA analysis

# 25,388 rows
myFieldDataSummarized

# 27894
myTestBattingDataClean

# We have a big dataset here, let's combine them with a left join and then scrub the nulls before we join to Data1

myData2 <- merge(x = myFieldDataSummarized, y = myTestBattingDataClean, by = "playerYear", all.x = TRUE)

myData2 <- 
myData2 %>%
  select(playerYear,playerID.x,A,E,DP,H,R,RBI,BB,SO)

# double checking my data and making sure it looks clean

myData2 %>%
  subset(playerID.x == "molinya01")

# Looks good, let's try and combine it with our age, and WH data

myData1

myData1$playerYear <-paste(myData1$playerID,myData1$yearID)

# ok this one is ready now
myData1

myData2 <-
  myData2 %>%
  rename(
    player_ID = playerID.x 
  )

myData2

myFinalData <- merge(x = myData1, y = myData2, by = "playerYear", all.x = TRUE)

myFinalData <- 
myFinalData %>%
  select(playerID,yearID,POS,G,WH,age,A,E,DP,H,R,RBI,BB,SO)
  
# is my data what I excpeted it to look like and is it right?
myFinalData %>%
  subset(playerID== "molinya01")

# time to clean the data befire analysis
na.omit(myFinalData)

# 71 + 13608
head(myFinalData)

# 13596 + 83
myFinalData <-
  myFinalData %>%
  select(yearID,POS,age,G,WH,A,E,DP,H,R,RBI,BB,SO)

myFinalData$POS[myFinalData$POS == "P"] <- 1
myFinalData$POS[myFinalData$POS == "C"] <- 2
myFinalData$POS[myFinalData$POS == "1B"] <- 3
myFinalData$POS[myFinalData$POS == "2B"] <- 4
myFinalData$POS[myFinalData$POS == "3B"] <- 5
myFinalData$POS[myFinalData$POS == "SS"] <- 6
myFinalData$POS[myFinalData$POS == "OF"] <- 7

myFinalData$POS <- as.numeric(as.character(myFinalData$POS))

# create dataframe

df <- myFinalData

myWHViz <-
df %>%
  filter(WH ==1) %>%
  group_by(POS) %>%
  summarise(G=mean(G))

ggplot(myWHViz, aes(x=factor(POS), y=G)) + stat_summary(fun.y="mean", geom="bar")

# preview data
head(df)
# take out Player ID for analysis
df <- df[-1]

df

set.seed(42)
samp <- sample(nrow(df), nrow(df)*0.8)
training <- df[samp, ]
testing <- df[-samp, ]

df.pca <- prcomp(training[,-4], center = T, scale=T) # Center and Scale, remove WH for this analysis
print(df.pca)
plot(df.pca, type="l")
summary(df.pca)

res.pca <- PCA(training[,-4], graph=F)

get_eig(res.pca)

fviz_screeplot(res.pca, addlables=TRUE, ylim=c(0,90))
var <- get_pca_var(res.pca)
var(head(var$contrib))

fviz_contrib(res.pca, choice="var", axes=1,top=10)
fviz_contrib(res.pca, choice="var", axes=2,top=10)
fviz_contrib(res.pca, choice="var", axes=3,top=10)

fviz_cos2(res.pca, choice = "var", axes = 1:2)

# Instead of using WH with PCA Analysis let's see if we can reduce our coefficents with Lasso
#dfNoWH <- 
#  df %>%
#    select(yearID,G,age,POS,A,E,DP,H,R,RBI,BB,SO)
# set.seed(88)
#train_control <- trainControl(method="cv", number=10)
#lasso <- train(G~.,dfNoWH,method="lasso",
               #preProc=c('scale','center'), trControl=train_control)

#lasso
#predict.enet(lasso$finalModel, type="coefficients", 
#             s=lasso$bestTune$fraction, mode="fraction")
               
# I wil remove Year, Runs, RBI, Assists

# come up with two GG plots that show Work Horse Games by position and the average starts by position


