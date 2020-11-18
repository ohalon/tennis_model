# SCRIPT FOR PROCESSING THE ODDS DATA
# SOURCE: http://www.tennis-data.co.uk/alldata.php

library(dplyr)
library(readr)
library(readxl)
library(openxlsx)


d_2011 <- read_excel('/home/alon/Documents/area51/data/odds/2011.xls')
d_2012 <- read_excel('/home/alon/Documents/area51/data/odds/2012.xls')
d_2013 <- read_excel('/home/alon/Documents/area51/data/odds/2013.xlsx')
d_2014 <- read_excel('/home/alon/Documents/area51/data/odds/2014.xlsx')
d_2015 <- read_excel('/home/alon/Documents/area51/data/odds/2015.xlsx')
d_2016 <- read_excel('/home/alon/Documents/area51/data/odds/2016.xlsx')
d_2017 <- read_excel('/home/alon/Documents/area51/data/odds/2017.xlsx')
d_2018 <- read_excel('/home/alon/Documents/area51/data/odds/2018.xlsx')
d_2019 <- read_excel('/home/alon/Documents/area51/data/odds/2019.xlsx')
d_2020 <- read_excel('/home/alon/Documents/area51/data/odds/2020.xlsx')


#REMOVING COLUMNS THAT ARE NOT FOUND IN ALL SETS (BOOKIE ODDS COLUMNS)
d_2011 = subset(d_2011, select = -c(SJL, SJW, LBL, LBW, EXL, EXW))
d_2012 = subset(d_2012, select = -c(SJL, SJW, LBL, LBW, EXL, EXW))
d_2013 = subset(d_2013, select = -c(SJL, SJW, LBL, LBW, EXL, EXW))
d_2014 = subset(d_2014, select = -c(SJL, SJW, LBL, LBW, EXL, EXW))
d_2015 = subset(d_2015, select = -c(LBL, LBW, EXL, EXW))
d_2016 = subset(d_2016, select = -c(LBL, LBW, EXL, EXW))
d_2017 = subset(d_2017, select = -c(LBL, LBW, EXL, EXW))
d_2018 = subset(d_2018, select = -c(LBL, LBW, EXL, EXW))

odds_data <- rbind(d_2011, d_2012, d_2013, d_2014, d_2015, d_2016, d_2017, d_2018, d_2019, d_2020)

# REMOVE MATCHES THAT DO NOT HAVE ODDS
odds_data <- odds_data[!is.na(odds_data$AvgW),]
odds_data <- odds_data[!is.na(odds_data$AvgL),]

# CREATE COLUMN WITH FAVOURITE WINNER = 1
for (i in 1:nrow(odds_data)) {
  if (odds_data$AvgW[i] < odds_data$AvgL[i]) {
    odds_data$fav_wins[i] <- 1
  }
  else odds_data$fav_wins[i] <- 0
}

write.xlsx(odds_data, "odds_data.xlsx")

odds_data$WPts <- as.numeric(odds_data$WPts)
odds_data$LPts <- as.numeric(odds_data$LPts)
odds_data$delta_points <-  odds_data$WPts - odds_data$LPts # New column

# Work around names for easier matching

odds_data$Winner <- gsub(" [a-zA-z].", "", odds_data$Winner)
odds_data$Loser <- gsub(" [a-zA-z].", "", odds_data$Loser)


for (i in 1:nrow(test)) {
  for (j in 1:nrow(test_match)) {
    odds_winner = test$Winner[i]
    match_winner = test_match$winner_name[j]
    odds_loser = test$Loser[i]
    match_loser = test_match$loser_name[j]
    odds_date = as.yearmon(test$Date[i])
    match_date = as.yearmon(test_match$tourney_date[j])
    
    if (grepl(match_winner, odds_winner) && grepl(match_loser, odds_loser) && grepl(match_date, odds_date)) {
      filler_match[i,] <- test_match[j,]}
  }
}
