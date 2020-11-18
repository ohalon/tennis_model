library(dplyr)
library(readr)
library(readxl)
library(openxlsx)
library(zoo)
library(doParallel)
library(tidyr)
library(reshape2)
odds_data <- read_excel('/home/alon/Documents/area51/data/odds_data.xlsx') #LOAD DATA
match_data <- read_excel('/home/alon/Documents/area51/data/match_data.xlsx')


odds_data$WPts <- as.numeric(odds_data$WPts)
odds_data$LPts <- as.numeric(odds_data$LPts)
odds_data$delta_points <-  odds_data$WPts - odds_data$LPts # New column ATP POINTS DIFFERENTIAL

# Work around names for easier matching, remove first names, all last names remaining in the end

odds_data$Winner <- gsub(" [a-zA-z].", "", odds_data$Winner)
odds_data$Loser <- gsub(" [a-zA-z].", "", odds_data$Loser)



# Transforming date and preparing names for match
match_data$tourney_date <- as.character(match_data$tourney_date)
match_data$tourney_date <- as.Date(match_data$tourney_date, format = "%Y%m%d")

match_data$winner_name <- gsub("[a-zA-Z]+ ", "", match_data$winner_name) # Similar to what is done above
match_data$loser_name <- gsub("[a-zA-Z]+ ", "", match_data$loser_name)
# MAKE COPIES OF DATA TO WORK WITH
test <- odds_data
test_match <- match_data
filler_match <- match_data
filler_match <- filler_match[1:nrow(odds_data),] #Create same number of rows as odds_data

# NEED FOR SPEED
test <-  as.matrix(test) # Use matrices to speed things up
test_match <- as.matrix(test_match)
filler_match <- as.matrix(filler_match)
rows_test = nrow(test)
rows_match = nrow(test_match)
for (i in 1:rows_test)  {
  test_winner = test[i,10]
  test_loser = test[i,11]
  test_date = as.yearmon(test[i,4])
  for (j in 1:rows_match) { 
    if ((test_winner == test_match[j,11]) && (test_loser == test_match[j,19])
        && (test_date == as.yearmon(test_match[j,6]))) {
      filler_match[i,] <- test_match[j,]}
  }
}
filler_match <- as.data.frame(filler_match)

# BIND DATA

good_data1 <- cbind(filler_match, test)
good_data2 <- good_data1

# Make row of NA where names do not match
for (i in 1:nrow(good_data1)) {if (good_data1$winner_name[i] != good_data1$Winner[i] || good_data1$loser_name[i] != good_data1$Loser[i]) {good_data2[i,] <- NA} }
good_data2 <- good_data2[apply(good_data2, 1, function(y) !all(is.na(y))),]

# Remove some useless columns
d <- d[,-c(1)]; d <- d[,-c(4)]; d <- d[,-c(6)]; d <- d[,-c(7)]; d <- d[,-c(6)]
d <- d[,-c(11)]; d <- d[,-c(11)]; d <- d[,-c(11)]; d <- d[,-c(42)]; d <- d[,-c(1)];d <- d[,-c(3)]; d <- d[,-c(40)]
set <- d
# sorting by date
set <- set[order(d$Date),]
set <- set[-c(1,2)]
# Move to excel for backup
write.xlsx(set, "dataset_v1.xlsx")
d1 <- read_excel('/home/alon/Documents/area51/data/dataset_v1.xlsx')
# ROW WITH TOTAL GAMES FOR EACH MATCH
d1$games <- rowSums(d1[,c("W1","L1","W2","L2","W3","L3","W4","L4","W5","L5")], na.rm=TRUE)
d1[,16:33] <- d1[, 16:33]/d1$games # Create per-game average of all the stats

write.xlsx(d1, "dataset_v2.xlsx")
d2 <- d1

# POINTS: FAVORITE - UNDERDOG
for (i in 1:nrow(d2)) {d2$delta_points[i] <- max(d2$WPts[i], d2$LPts[i]) - min(d2$WPts[i], d2$LPts[i])}
# HEIGHT: FAVORITE - UNDERDOG
d2$delta_ht <- ifelse(d2$WRank < d2$LRank, d2$winner_ht-d2$loser_ht, d2$loser_ht - d2$winner_ht)
# AGE: FAVORITE - UNDERDOG
d2$delta_age <- ifelse(d2$WRank < d2$LRank, d2$winner_age - d2$loser_age, d2$loser_age - d2$winner_age)
# RANK: FAVORITE - UNDERDOG
d2$delta_rank <- ifelse(d2$WRank < d2$LRank, d2$WRank - d2$LRank, d2$LRank - d2$WRank)
# ODDS RATIO: large odds/small odds
for (i in 1:nrow(d2)) {d2$odds_ratio[i] <- max(d2$AvgW[i], d2$AvgL[i])/min(d2$AvgW[i], d2$AvgL[i])}

# As factor:

d2$Surface <- as.factor(d2$Surface)
d2$winner_hand <- as.factor(d2$winner_hand)
d2$loser_hand <- as.factor(d2$loser_hand)
setwd('/home/alon/Documents/area51/data/')
write.xlsx(d2, "dataset_v3.xlsx")

# Get missing heights..
a <- data.frame(matrix(NA, nrow = nrow(d2), ncol = 2))
for (i in 1:nrow(d2)) {if (is.na(d2$winner_ht[i])) {a[i,1] <- d2$winner_name[i]} else {next}}
for (i in 1:nrow(d2)) {if (is.na(d2$loser_ht[i])) {a[i,2] <- d2$loser_name[i]} else {next}}
a <- data.frame(a = c(df[,"a"], df[,"b"]))
a <- melt(a, na.rm = TRUE)
a <- melt(a, na.rm = TRUE, id = c("X1"))
a <- a[,3]

# CHANGE TOURNAMENTS TO COUNTRY CODES
setwd('/home/alon/Documents/area51/data/')
write.xlsx(d2, "dataset_v4.xlsx")
d3 <- dataset_v4
#Remove Wrank and Lrank NAs
d3 <- d3[-c(5469, 8329, 8354, 8735, 10823, 17428), ]
d3 <- d3[-c(942,2357,2365,3566,4539,5395,5493,8170,8338,8366,
            8744,9015,9743,9750,10603,10802,10840,11020,11573,
            11648,12373,12443,13105,15371,15473,15497,15535,16451,16705,17139,17354,17368,17447), ]


d3$fav_home <- 0
for (i in 1:nrow(d3)) {
  if (d3$WRank[i] < d3$LRank[i]) {
    if (d3$winner_ioc[i] == d3$Tournament[i]) {d3$fav_home[i] = 1}
  else if (d3$LRank[i] < d3$WRank[i]) {
    if (d3$loser_ioc[i] == d3$Tournament[i]) {d3$fav_home[i] = 1}
  }
    }
}

d3$under_home <- 0
for (i in 1:nrow(d3)) {
  if (d3$LRank[i] < d3$WRank[i]) {
    if (d3$winner_ioc[i] == d3$Tournament[i]) {d3$under_home[i] = 1}
  else if (d3$WRank[i] < d3$LRank[i]) {
    if (d3$loser_ioc[i] == d3$Tournament[i]) {d3$under_home[i] = 1}
  }  
  }
}

write.xlsx(d3, "dataset_v5.xlsx")
# REDOING ODDS RATIO AS ODDS FAV/ODDS UNDERDOG (BY ATP RANK)

d3$odds_ratio <- ifelse(d3$WRank < d3$LRank, d3$AvgW/d3$AvgL, d3$AvL/d3$AvW)

write.xlsx(d3, "dataset_v6.xlsx")

d4$odds <- ifelse(d4$WRank < d4$LRank, d4$AvgW, d4$AvgL)