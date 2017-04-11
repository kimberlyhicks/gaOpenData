library(RGoogleAnalytics)
library(rsconnect)
library(data.table)

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

query.list.all.events <- Init(start.date = "2016-10-01",
                        end.date = end_date,
                        dimensions = "ga:date,ga:country,ga:city,ga:eventCategory,ga:eventAction,ga:userType,ga:eventLabel",
                        metrics = "ga:users,ga:sessions,ga:avgSessionDuration,ga:newUsers",
                        #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                        max.results = 50000,
                        sort = "ga:date",
                        table.id = "ga:90055082")

query.list.all <- Init(start.date = "2016-10-01",
                       end.date = end_date,
                       dimensions = "ga:date,ga:country,ga:metro,ga:city,ga:eventCategory,ga:eventAction,ga:userType",
                       metrics = "ga:users,ga:sessions,ga:avgSessionDuration,ga:newUsers",
                       #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                       max.results = 50000,
                       sort = "ga:date",
                       table.id = "ga:90055082")


query.list.int <- Init(start.date = "2016-10-01",
                    end.date = end_date,
                    dimensions = "ga:date,ga:country,ga:metro,ga:city,ga:eventCategory,ga:eventAction,ga:userType",
                    metrics = "ga:users,ga:sessions,ga:avgSessionDuration,ga:newUsers",
                    #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                    max.results = 10000,
                    sort = "ga:date",
                    table.id = "ga:147171182")

query.list.ext <- Init(start.date = "2016-10-01",
                       end.date = end_date,
                       dimensions = "ga:date,ga:country,ga:metro,ga:city,ga:eventCategory,ga:eventAction,ga:userType",
                       metrics = "ga:users,ga:sessions,ga:avgSessionDuration,ga:newUsers",
                       #segment = "users::sequence::^ga:userType==New%20Visitor;dateOfSession<>2014-09-01_2014-09-07;ga:campaign==Campaign%20A;->>perSession::ga:transactions>0",
                       max.results = 10000,
                       sort = "ga:date",
                       table.id = "ga:147112057")





# Create the Query Builder object so that the query parameters are validated
ga.query.all <- QueryBuilder(query.list.all)
ga.query.int <- QueryBuilder(query.list.int)
ga.query.ext <- QueryBuilder(query.list.ext)

# Extract the data and store it in a data-frame
ga.data.all <-  GetReportData(ga.query.all, token, paginate_query = TRUE)
ga.data.int <- GetReportData(ga.query.int, token)
ga.data.ext <- GetReportData(ga.query.ext, token)

ga.all.location <- ifelse(ga.data.all[ , "city"] == 'San Francisco' , 'SF' , 
                          ifelse(ga.data.all[ , "metro"] == 'San Francisco-Oakland-San Jose CA' , 'SF metro' ,
                                 ifelse(ga.data.all[ , "country" == "United States"] , 'U.S.' ,
                                        'Outside U.S.')))

ga.mush <- rbind(data.table(mutate(ga.data.all , 
                                   source = rep("All" , nrow(ga.data.all)) , 
                                   loc_funnel = ifelse(ga.data.all[ , "city"] == 'San Francisco' , 'SF' , 
                                                  ifelse(ga.data.all[ , "metro"] == 'San Francisco-Oakland-San Jose CA' , 'SF metro' ,
                                                    ifelse(ga.data.all[ , "country"] == "United States" , 'U.S.' ,
                                                        'Outside U.S.')))
                                   )
                            ), 
                 data.table(mutate(ga.data.int , 
                                   source = rep("Internal" , nrow(ga.data.int)) , 
                                   loc_funnel = ifelse(ga.data.int[ , "city"] == 'San Francisco' , 'SF' , 
                                                       ifelse(ga.data.int[ , "metro"] == 'San Francisco-Oakland-San Jose CA' , 'SF metro' ,
                                                              ifelse(ga.data.int[ , "country"] == "United States" , 'U.S.' ,
                                                                     'Outside U.S.')))
                                   )
                            ), 
                 data.table(mutate(ga.data.ext , 
                                   source = rep("External" , nrow(ga.data.ext)) , 
                                   loc_funnel = ifelse(ga.data.ext[ , "city"] == 'San Francisco' , 'SF' , 
                                                       ifelse(ga.data.ext[ , "metro"] == 'San Francisco-Oakland-San Jose CA' , 'SF metro' ,
                                                              ifelse(ga.data.ext[ , "country"] == "United States" , 'U.S.' ,
                                                                     'Outside U.S.')))
                                   )
                            )
                 )


# Sanity Check for column names
# dimnames(ga.data)

# Check the size of the API Response
# dim(ga.data)

