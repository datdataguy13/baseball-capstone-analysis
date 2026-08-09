library(Lahman)
library(tidyverse)
library(dplyr)
library(factoextra)
library(cluster.datasets)
library(cluster)
 data(HallOfFame)
 data(AwardsPlayers)
 data(AllstarFull)
 data(People)
 
 #head(HallOfFame)
 myDataHOF <- HallOfFame
 
 myDataHOF <- myDataHOF %>%
   select(playerID,votedBy,ballots,needed,votes,needed_note) %>%
   filter(myDataHOF$inducted =="Y" &  myDataHOF$category =="Player")
 
myDataPlayerAwards <- AwardsPlayers
# It looks like the platinum glove and fielding bible are not included in the awards table, no worries :) We will focus on the Gold Glove
myDataPlayerAwards %>%
  subset(playerID == "molinya01")

myDataAllStar <- AllstarFull
# Count Year ID to get count of all star games
myDataAllStar %>%
subset(playerID == "molinya01")

myDataHOF <- merge(myDataHOF,People, by="playerID")
  
# Keep a detail view of data incase I want to come back and do more analysis                
myDetailHOFData <- myDataHOF %>%
  select(playerID,nameFirst,nameLast,votedBy,ballots,needed,votes,needed_note,weight,height,bats,throws,birthCity,birthState,debut,finalGame)

# Some players didn't play in the era of gold gloves and all star games - 1933 was the first All Star Game and 1957 was the first year Gold Gloves were awarded
myDataPlayerAwards %>%
  subset(playerID == "youngcy01")

myDataAllStar %>%
  subset(playerID == "aaronha01")

# Find out how many players and who we are excluding from our Kmeans clustering
myDataHOFHist <- myDetailHOFData %>%
  select(playerID,nameFirst,nameLast) %>%
  filter(myDetailHOFData$finalGame < '1957-01-01')
# WOW 131 players

# Let's only look at players that played when these awards and all star games happened.
myDataHOF <- myDetailHOFData %>%
  select(playerID,nameFirst,nameLast) %>%
   filter(myDetailHOFData$finalGame > '1957-01-01')

# we are only looking at 99 players
myDataHOF

# Let's make name one column
myDataHOF$Name <- paste(myDataHOF$nameFirst,myDataHOF$nameLast)

myDataHOF <-
myDataHOF %>%
  select(playerID,Name)

# Here is a rough way I am going to get a count of Gold Gloves
myDataPlayerAwards <- 
myDataPlayerAwards %>%
  subset( awardID =="Gold Glove") %>%
  count(playerID)


# Gold Gloves as a column header is more descriptive than N
myGoldGLoves <-
myDataPlayerAwards %>%
  rename(
    GoldGLoves = n
  )

# Let's do something similair with All Star games by player

myAllStarDataTrend <-
myDataAllStar %>%
  count(playerID)

myDataHOF <- merge(x = myDataHOF, y = myAllStarDataTrend, by = "playerID", all.x = TRUE)

# Now it is looing good, let's bring over the Gold GLoves
myDataHOF <- merge(x = myDataHOF, y =myGoldGLoves , by = "playerID", all.x = TRUE)

# looking good - Let's try running our model with NAs if it doesn't work we can reset it and set the NAs to 0s and call it out in our findings
myDataHOF

myDataHOF <-
myDataHOF %>%
  rename(
    AllStarGames = n
  )

# Taking out PlayerID for model
myDataHOF <-
  myDataHOF %>%
    select(Name,AllStarGames,GoldGLoves)

# The model will not run with 0s 
myDataHOF[is.na(myDataHOF)] = 0

myDataHOF

mydata_tib <- as_tibble(myDataHOF)

#K-Means Cluster
set.seed(1234)
y <- mydata_tib$Name #segregate dependent variable
x<- mydata_tib[2:3] #segregate independent variables
k_means_fit <- kmeans(x,3)

table_kmeans <- table(y,k_means_fit$cluster)
table_kmeans 


plot(x[c("AllStarGames", "GoldGLoves")], col = k_means_fit$cluster, main = "K-Means algorithm")
points(k_means_fit$centers[,c("AllStarGames", "GoldGLoves")], col=1:3, pch=23, cex=3)
text(x, y , labels = k_means_fit$Name)

#
y <- mydata_tib$Name #segregate dependent variable
x<- mydata_tib[2:3] #segregate independent variables
d <- dist(x, method = "euclidean")      # Dissimilarity matrix
hc1 <- hclust(d, method = "complete" )
sub_grp <- cutree(hc1, k = 3)      # Cut tree into 3 groups or at level 3
table(y, sub_grp)

fviz_cluster(list(data = x, cluster = sub_grp))
# well it didn't fit 
text(x, y , labels = k_means_fit$Name)

