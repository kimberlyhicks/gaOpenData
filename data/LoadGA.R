library(RGoogleAnalytics)
library(rsconnect)
library(data.table)
library(dplyr)
library(curl)

#setwd('C:\\Users\\khicks\\Documents')
#load("./token_file")

client.id  <- "268423040455-rdo08tdhqokdg7dq97593sku6nbrsg4u.apps.googleusercontent.com"
client.secret <- "nFbXd0JqrhH-DOsLBC9jcLgt"

token <- Auth(client.id,client.secret)

# Validate and refresh the token
ValidateToken(token)

# Get the Sessions & Transactions for each Source/Medium sorted in 
# descending order by the Transactions

# ga:eventAction,ga:eventLabel

end_year <- year(today())
end_month <- ifelse(nchar(month(today())) == 1, paste("0", month(today()), sep = ""), month(today()))
end_day <- ifelse(nchar(day(today())) == 1, paste("0", day(today()), sep = ""), day(today()))
end_date <- paste(end_year,"-",end_month,"-",end_day,sep="")

start_date <- "2016-10-01"

query.list.all.users <- Init(start.date = start_date,
                          end.date = end_date,
                          dimensions = "ga:date,ga:country,ga:region,ga:metro,ga:city,ga:userType",
                          metrics = "ga:users,ga:sessions,ga:avgSessionDuration",
                          #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                          max.results = 50000,
                          sort = "ga:date",
                          table.id = "ga:90055082")

query.list.all.cat <- Init(start.date = start_date,
                              end.date = end_date,
                              dimensions = "ga:date,ga:country,ga:region,ga:metro,ga:city,ga:eventCategory,ga:userType",
                              metrics = "ga:users,ga:sessions,ga:avgSessionDuration",
                              #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                              max.results = 50000,
                              sort = "ga:date",
                              table.id = "ga:90055082")
query.list.int.cat <- Init(start.date = start_date,
                           end.date = end_date,
                           dimensions = "ga:date,ga:country,ga:region,ga:metro,ga:city,ga:eventCategory,ga:userType",
                           metrics = "ga:users,ga:sessions,ga:avgSessionDuration",
                           #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                           max.results = 50000,
                           sort = "ga:date",
                           table.id = "ga:147171182")
query.list.ext.cat <- Init(start.date = start_date,
                           end.date = end_date,
                           dimensions = "ga:date,ga:country,ga:region,ga:metro,ga:city,ga:eventCategory,ga:userType",
                           metrics = "ga:users,ga:sessions,ga:avgSessionDuration",
                           #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                           max.results = 50000,
                           sort = "ga:date",
                           table.id = "ga:147112057")

query.list.all.events <- Init(start.date = start_date,
                          end.date = end_date,
                          dimensions = "ga:date,ga:country,ga:city,ga:eventCategory,ga:eventAction,ga:eventLabel,ga:userType",
                          metrics = "ga:users,ga:sessions,ga:avgSessionDuration,ga:newUsers",
                          #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                          max.results = 50000,
                          sort = "ga:date",
                          table.id = "ga:90055082")


query.list.int.events <- Init(start.date = start_date,
                            end.date = end_date,
                            dimensions = "ga:date,ga:country,ga:city,ga:eventCategory,ga:eventAction,ga:eventLabel,ga:userType",
                            metrics = "ga:users,ga:sessions,ga:avgSessionDuration,ga:newUsers",
                            #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                            max.results = 10000,
                            sort = "ga:date",
                            table.id = "ga:147171182")

query.list.ext.events <- Init(start.date = start_date,
                            end.date = end_date,
                            dimensions = "ga:date,ga:country,ga:city,ga:eventCategory,ga:eventAction,ga:eventLabel,ga:userType",
                            metrics = "ga:users,ga:sessions,ga:avgSessionDuration,ga:newUsers",
                            #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                            max.results = 10000,
                            sort = "ga:date",
                            table.id = "ga:147112057")





# Create the Query Builder object so that the query parameters are validated
ga.query.all.events <- QueryBuilder(query.list.all.events)
ga.query.int.events <- QueryBuilder(query.list.int.events)
ga.query.ext.events <- QueryBuilder(query.list.ext.events)

ga.query.all.users <- QueryBuilder(query.list.all.users)

ga.query.all.cat <- QueryBuilder(query.list.all.cat)
ga.query.int.cat <- QueryBuilder(query.list.int.cat)
ga.query.ext.cat <- QueryBuilder(query.list.ext.cat)

# Extract the data and store it in a data-frame
ga.data.all.events <-  GetReportData(ga.query.all.events, token)
ga.data.int.events <- GetReportData(ga.query.int.events, token)
ga.data.ext.events <- GetReportData(ga.query.ext.events, token)

ga.data.all.users <- GetReportData(ga.query.all.users, token, paginate_query = TRUE)

ga.data.all.cat <-  GetReportData(ga.query.all.cat, token)
ga.data.int.cat <- GetReportData(ga.query.int.cat, token)
ga.data.ext.cat <- GetReportData(ga.query.ext.cat, token)



data.all.events <- mutate(ga.data.all.events , 
                          source = rep("All" , nrow(ga.data.all.events)) 
)

data.all.users <- mutate(ga.data.all.users , 
                         source = rep("All" , nrow(ga.data.all.users)) , 
                         engagementEvent = rep('<Overall Baseline>' , nrow(ga.data.all.users)) 
                        )
data.all.cat <- select(
                  mutate(ga.data.all.cat , 
                          source = rep("All" , nrow(ga.data.all.cat)) , 
                          engagementEvent = eventCategory) ,
                  date , country , region , metro , city , userType , users , sessions , avgSessionDuration , source , engagementEvent
                  )

data.int.cat <- select(
                  mutate(ga.data.int.cat , 
                         source = rep("Internal" , nrow(ga.data.int.cat)) , 
                         engagementEvent = eventCategory) ,
                  date , country , region , metro , city , userType , users , sessions , avgSessionDuration , source , engagementEvent
                )

data.ext.cat <- select(
                  mutate(ga.data.ext.cat , 
                          source = rep("External" , nrow(ga.data.ext.cat)) , 
                          engagementEvent = eventCategory) ,
                  date , country , region , metro , city , userType , users , sessions , avgSessionDuration , source , engagementEvent
                )


ga.mush <- rbind(data.all.users , data.all.cat , data.int.cat , data.ext.cat )
                            

# Sanity Check for column names
# dimnames(ga.data)

# Check the size of the API Response
# dim(ga.data)

