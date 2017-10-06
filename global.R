data.master <- readRDS('data/data.master.rds' )
data.master.E <- readRDS('data/data.master.E.rds')
data.master.P <- readRDS('data/data.master.P.rds')


library(shiny)
library(plotly)
library(dtplyr)
library(lubridate)
library(DT)
#library(d3Tree)
#library(jsonlite)
library(data.table)

# Reformat date on each data set.  
data <- mutate(data.master,
               useDate = ymd(date) 
)
names(data) <- c("rownames", "date" , "networkLocation" , "deviceCategory" , "cityId" , "users" , "newUsers" ,  
                 "sessions" , "sessionDuration" , "goal1completions" , "goal2completions" , "Bounces" , 
                 "userType" , "userCount" , "userGroup" , "source" , "SF" , "Bay" , "CA" , "US" , "NotUS" ,           
                 "NoCity" , "LocationAll" , "groupNetwork" , "useDate")

data.E <- mutate(data.master.E,
                 useDate = ymd(date) 
)
names(data.E) <- c("rownames", "date" , "networkLocation" , "deviceCategory" , "cityId" , "eventCategory" , 
                   "eventAction" , "eventLabel" , "users" , "newUsers" ,  "sessions" , 
                   "sessionDuration" , "userType" , "userCount" , "userGroup" , "source" , 
                   "SF" , "Bay" , "CA" , "US" , "NotUS" , "NoCity" , "LocationAll" , "groupNetwork"  , "useDate")
data.P <- mutate(data.master.P,
                 useDate = ymd(date) 
)
names(data.P) <- c("rownames", "date" , "networkLocation" , "deviceCategory" , "cityId" , "fullReferrer" , 
                   "landingPagePath" , "exitPagePath" , "users" , "newUsers" ,  "sessions" , 
                   "sessionDuration" , "goal1completions" , "goal2completions" , "Bounces" , "userType" , 
                   "userCount" , "userGroup" , "source" , "SF" , "Bay" , "CA" , "US" , 
                   "NotUS" , "NoCity" , "LocationAll" , "groupNetwork"  , "useDate")

yesterday <- as.character(today() - days(1))

start_date <- "2017-04-01"


