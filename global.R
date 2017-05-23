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
#library(data.table)

# Reformat date on each data set.  
data <- mutate(data.master,
               useDate = ymd(date) 
)
data.E <- mutate(data.master.E,
                 useDate = ymd(date) 
)
data.P <- mutate(data.master.P,
                 useDate = ymd(date) 
)


#require("RPostgreSQL")
#pw <- {
#  'shinyapp'
#}

#con <- src_postgres(dbname = 'shiny' ,
#             host = '162.243.137.94' ,
#             port = 5432 ,
#             user = 'shiny' ,
#             password = pw)
#data.master <- tbl(con , 'data.master')
#data.master.E <- tbl(con , 'data.master.E')
#data.master.P <- tbl(con , 'data.master.P')

nrow(subset(data.master , date == '20170504'))
nrow(subset(data.master.P , date == '20170504'))
nrow(subset(data.master.E , date == '20170504'))

#drv <- dbDriver('PostgreSQL')
#dbListConnections(drv)
#con <- dbConnect(drv , dbname = 'shiny' , 
#                 host = '162.243.137.94' , port = 5432 ,
#                 user = 'shiny' , password = 'shinyapp')
#dbListTables(con)

#dbWriteTable(con , 'data.master' , data.master)
#dbWriteTable(con , 'data.master.E' , data.master.E)
#dbWriteTable(con , 'data.master.P' , data.master.P)


#data.master <- dbReadTable(con , 'data.master')
#data.master.E <- dbReadTable(con , 'data.master.E')
#data.master.P <- dbReadTable(con , 'data.master.P')


#end_year <- year(today())
#end_month <- ifelse(nchar(month(today())) == 1, paste("0", month(today()), sep = ""), month(today()))
#end_day <- ifelse(nchar(day(today())) == 1, paste("0", day(today()), sep = ""), day(today()))
#end_date <- paste(end_year,"-",end_month,"-",end_day,sep="")

yesterday <- as.character(today() - days(1))

start_date <- "2017-04-01"


#source("data/LoadGA.R")
#saveRDS(data.master , 'data/data.master.rds')
#saveRDS(data.master.E , 'data/data.master.E.rds')
#saveRDS(data.master.P , 'data/data.master.P.rds')

