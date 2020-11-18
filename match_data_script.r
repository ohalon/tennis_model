# SCRIPT FOR PROCESSING MATCH DATA
# SOURCE: LOOK INTO GET_DATA.SH FILE

library(dplyr)
library(readr)
library(readxl)
library(openxlsx)
library(zoo)
library(doParallel)

m_2011 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2011.csv')
m_2012 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2012.csv')
m_2013 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2013.csv')
m_2014 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2014.csv')
m_2015 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2015.csv')
m_2016 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2016.csv')
m_2017 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2017.csv')
m_2018 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2018.csv')
m_2019 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2019.csv')
m_2020 <- read_csv('/home/alon/Documents/area51/data/matches/atp_matches_2020.csv')

match_data <- rbind(m_2011, m_2012, m_2013, m_2014, m_2015, m_2016, m_2017, m_2018, m_2019, m_2020)
write.xlsx(match_data, "match_data.xlsx")

