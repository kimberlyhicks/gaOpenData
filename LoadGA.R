require(methods)

library(RGoogleAnalytics)
library(rsconnect)
library(data.table)
library(dplyr)
library(curl)

source('C:/Users/khicks/Documents/GAshinyApp/gaOpenData/data/networkGroup.R')
source('C:/Users/khicks/Documents/GAshinyApp/token_file.R')

yesterday <- as.character(today() - days(1))
start_date <- as.character(today() - days(2))

ValidateToken(token)

# Set up queries: tailoring dimensions + adjusting segments
query.location <- Init(start.date = start_date,
                       end.date = yesterday,
                       dimensions = "ga:cityId,ga:city,ga:metro,ga:region,ga:country",
                       metrics = "ga:users",
                       #       segment = "gaid::qIVsEVtkSIK-joGhVZUJ7w",
                       max.results = 500001,
                       sort = "ga:cityId",
                       table.id = "ga:90055082")

query.all <- Init(start.date = start_date,
                             end.date = yesterday,
                             dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId",
                             metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                      #       segment = "gaid::qIVsEVtkSIK-joGhVZUJ7w",
                             max.results = 500001,
                            sort = "ga:date",
                             table.id = "ga:90055082")

query.all.E <- Init(start.date = start_date,
                  end.date = yesterday,
                  dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:eventCategory,ga:eventAction,ga:eventLabel",
                  metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration",
                  #       segment = "gaid::qIVsEVtkSIK-joGhVZUJ7w",
                  max.results = 500001,
                  sort = "ga:date",
                  table.id = "ga:90055082")

query.all.P <- Init(start.date = start_date,
                  end.date = yesterday,
                  dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:fullReferrer,ga:landingPagePath,ga:exitPagePath",
                  metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                  #       segment = "gaid::qIVsEVtkSIK-joGhVZUJ7w",
                  max.results = 800001,
                  sort = "ga:date",
                  table.id = "ga:90055082")



query.datasets <- Init(start.date = start_date,
                      end.date = yesterday,
                      dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId",
                      metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                      segment = "gaid::Eg5V8wOQRpCIexcSnbvu-g",
                      max.results = 500001,
                      sort = "ga:date",
                      table.id = "ga:90055082")

query.datasets.E <- Init(start.date = start_date,
                       end.date = yesterday,
                       dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:eventCategory,ga:eventAction,ga:eventLabel",
                       metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration",
                       segment = "gaid::Eg5V8wOQRpCIexcSnbvu-g",
                       max.results = 500001,
                       sort = "ga:date",
                       table.id = "ga:90055082")
query.datasets.P <- Init(start.date = start_date,
                       end.date = yesterday,
                       dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:fullReferrer,ga:landingPagePath,ga:exitPagePath",
                       metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                       segment = "gaid::Eg5V8wOQRpCIexcSnbvu-g",
                       max.results = 800001,
                       sort = "ga:date",
                       table.id = "ga:90055082")


query.engaged <- Init(start.date = start_date,
                          end.date = yesterday,
                          dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId",
                          metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                          segment = "gaid::mE3Me2ReTECaM82Kuuvc7Q",
                          max.results = 500001,
                          sort = "ga:date",
                          table.id = "ga:90055082")
query.engaged.E <- Init(start.date = start_date,
                      end.date = yesterday,
                      dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:eventCategory,ga:eventAction,ga:eventLabel",
                      metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration",
                      segment = "gaid::mE3Me2ReTECaM82Kuuvc7Q",
                      max.results = 500001,
                      sort = "ga:date",
                      table.id = "ga:90055082")
query.engaged.P <- Init(start.date = start_date,
                      end.date = yesterday,
                      dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:fullReferrer,ga:landingPagePath,ga:exitPagePath",
                      metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                      segment = "gaid::mE3Me2ReTECaM82Kuuvc7Q",
                      max.results = 800001,
                      sort = "ga:date",
                      table.id = "ga:90055082")

query.copy <- Init(start.date = start_date,
                      end.date = yesterday,
                      dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId",
                      metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                      segment = "gaid::CEgHWyCcRvSRgSxoaGBDVg",
                      max.results = 500001,
                      sort = "ga:date",
                      table.id = "ga:90055082")
query.copy.E <- Init(start.date = start_date,
                        end.date = yesterday,
                        dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:eventCategory,ga:eventAction,ga:eventLabel",
                        metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration",
                        segment = "gaid::CEgHWyCcRvSRgSxoaGBDVg",
                        max.results = 500001,
                        sort = "ga:date",
                        table.id = "ga:90055082")
query.copy.P <- Init(start.date = start_date,
                   end.date = yesterday,
                   dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:fullReferrer,ga:landingPagePath,ga:exitPagePath",
                   metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                   segment = "gaid::CEgHWyCcRvSRgSxoaGBDVg",
                   max.results = 800001,
                   sort = "ga:date",
                   table.id = "ga:90055082")


query.download <- Init(start.date = start_date,
                   end.date = yesterday,
                   dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId",
                   metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                   segment = "gaid::Kt_eA3CaS3S1t_vDagOVsA",
                   max.results = 500001,
                   sort = "ga:date",
                   table.id = "ga:90055082")
query.download.E <- Init(start.date = start_date,
                     end.date = yesterday,
                     dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:eventCategory,ga:eventAction,ga:eventLabel",
                     metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration",
                     segment = "gaid::Kt_eA3CaS3S1t_vDagOVsA",
                     max.results = 500001,
                     sort = "ga:date",
                     table.id = "ga:90055082")
query.download.P <- Init(start.date = start_date,
                       end.date = yesterday,
                       dimensions = "ga:date,ga:networkLocation,ga:deviceCategory,ga:cityId,ga:fullReferrer,ga:landingPagePath,ga:exitPagePath",
                       metrics = "ga:users,ga:newUsers,ga:sessions,ga:sessionDuration,ga:goal1completions,ga:goal2completions,ga:Bounces",
                       segment = "gaid::Kt_eA3CaS3S1t_vDagOVsA",
                       max.results = 800001,
                       sort = "ga:date",
                       table.id = "ga:90055082")


# Create the Query Builder object so that the query parameters are validated
ga.query.all.L <- QueryBuilder(query.location)

ga.query.all <- QueryBuilder(query.all)
ga.query.dat <- QueryBuilder(query.datasets)
ga.query.eng <- QueryBuilder(query.engaged)
ga.query.cpy <- QueryBuilder(query.copy)
ga.query.dwn <- QueryBuilder(query.download)

ga.query.all.E <- QueryBuilder(query.all.E)
ga.query.dat.E <- QueryBuilder(query.datasets.E)
ga.query.eng.E <- QueryBuilder(query.engaged.E)
ga.query.cpy.E <- QueryBuilder(query.copy.E)
ga.query.dwn.E <- QueryBuilder(query.download.E)

ga.query.all.P <- QueryBuilder(query.all.P)
ga.query.dat.P <- QueryBuilder(query.datasets.P)
ga.query.eng.P <- QueryBuilder(query.engaged.P)
ga.query.cpy.P <- QueryBuilder(query.copy.P)
ga.query.dwn.P <- QueryBuilder(query.download.P)


# Extract the data and store it in a data-frame
ga.data.L <- GetReportData(ga.query.all.L, token)

ga.data.all <- GetReportData(ga.query.all, token)
ga.data.dat <- GetReportData(ga.query.dat, token)
ga.data.eng <- GetReportData(ga.query.eng, token)
ga.data.cpy <- GetReportData(ga.query.cpy, token)
ga.data.dwn <- GetReportData(ga.query.dwn, token)

ga.data.all.E <- GetReportData(ga.query.all.E, token)
ga.data.dat.E <- GetReportData(ga.query.dat.E, token)
ga.data.eng.E <- GetReportData(ga.query.eng.E, token)
ga.data.cpy.E <- GetReportData(ga.query.cpy.E, token)
ga.data.dwn.E <- GetReportData(ga.query.dwn.E, token)

ga.data.all.P <- GetReportData(ga.query.all.P, token)
ga.data.dat.P <- GetReportData(ga.query.dat.P, token)
ga.data.eng.P <- GetReportData(ga.query.eng.P, token)
ga.data.cpy.P <- GetReportData(ga.query.cpy.P, token)
ga.data.dwn.P <- GetReportData(ga.query.dwn.P, token)

# Get location ids.
idSF <- unique(subset(ga.data.L , city == 'San Francisco' )$cityId)
idBay <- unique(subset(ga.data.L , metro == 'San Francisco-Oakland-San Jose CA' )$cityId)
idCA <- unique(subset(ga.data.L , region == 'California' )$cityId)
idUS <- unique(subset(ga.data.L , country == 'United States' )$cityId)
idNotUS <- unique(subset(ga.data.L , country != 'United States' & cityId != '(not set)')$cityId)
idNone <- unique(subset(ga.data.L , cityId == '(not set)')$cityId)

# now get creative with new/returning ...
rtnUsers.all <- subset(mutate(ga.data.all ,
                       rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.all <- subset(ga.data.all , newUsers > 0)

rtn.all <- select(mutate(rtnUsers.all , 
                    userType = rep("Returning Visitor" , nrow(rtnUsers.all)) , 
                    userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , users , newUsers , sessions , sessionDuration , 
                  goal1completions , goal2completions , Bounces , userType , userCount)
new.all <- mutate(newUsers.all , 
                  userType = rep("New Visitor" , nrow(newUsers.all)) , 
                  userCount = newUsers)

data.all <- mutate(rbind(rtn.all , new.all) ,
                   userGroup = 'All')

rtnUsers.dat <- subset(mutate(ga.data.dat ,
                              rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.dat <- subset(ga.data.dat , newUsers > 0)


rtn.dat <- select(mutate(rtnUsers.dat , 
                         userType = rep("Returning Visitor" , nrow(rtnUsers.dat)) , 
                         userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , users , newUsers , sessions , sessionDuration , 
                  goal1completions , goal2completions , Bounces , userType , userCount)
new.dat <- mutate(newUsers.dat , 
                  userType = rep("New Visitor" , nrow(newUsers.dat)) , 
                  userCount = newUsers)
data.dat <- mutate(rbind(rtn.dat , new.dat) ,
                   userGroup = 'DatasetUsers')


rtnUsers.eng <- subset(mutate(ga.data.eng ,
                              rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.eng <- subset(ga.data.eng , newUsers > 0)


rtn.eng <- select(mutate(rtnUsers.eng , 
                         userType = rep("Returning Visitor" , nrow(rtnUsers.eng)) , 
                         userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , users , newUsers , sessions , sessionDuration , 
                  goal1completions , goal2completions , Bounces , userType , userCount)
new.eng <- mutate(newUsers.eng , 
                  userType = rep("New Visitor" , nrow(newUsers.eng)) , 
                  userCount = newUsers)
data.eng <- mutate(rbind(rtn.eng , new.eng) ,
                   userGroup = 'engagedUsers')

rtnUsers.cpy <- subset(mutate(ga.data.cpy ,
                              rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.cpy <- subset(ga.data.cpy , newUsers > 0)


rtn.cpy <- select(mutate(rtnUsers.cpy , 
                         userType = rep("Returning Visitor" , nrow(rtnUsers.cpy)) , 
                         userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , users , newUsers , sessions , sessionDuration , 
                  goal1completions , goal2completions , Bounces , userType , userCount)
new.cpy <- mutate(newUsers.cpy , 
                  userType = rep("New Visitor" , nrow(newUsers.cpy)) , 
                  userCount = newUsers)
data.cpy <- mutate(rbind(rtn.cpy , new.cpy) ,
                   userGroup = 'copyUsers')

rtnUsers.dwn <- subset(mutate(ga.data.dwn ,
                              rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.dwn <- subset(ga.data.dwn , newUsers > 0)


rtn.dwn <- select(mutate(rtnUsers.dwn , 
                         userType = rep("Returning Visitor" , nrow(rtnUsers.dwn)) , 
                         userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , users , newUsers , sessions , sessionDuration , 
                  goal1completions , goal2completions , Bounces , userType , userCount)
new.dwn <- mutate(newUsers.dwn , 
                  userType = rep("New Visitor" , nrow(newUsers.dwn)) , 
                  userCount = newUsers)
data.dwn <- mutate(rbind(rtn.dwn , new.dwn) ,
                   userGroup = 'downloadUsers')

dat <- mutate(rbind(data.all , data.dat , data.eng , data.cpy , data.dwn) ,
                      source = ifelse(grepl('ccsf' , networkLocation , ignore.case = TRUE) | 
                                      grepl('san francisco department of telecommunications and information s' , networkLocation , ignore.case = TRUE) | 
                                      grepl('san francisco public library'  , networkLocation , ignore.case = TRUE) | 
                                      grepl('san francisco international airport' , networkLocation , ignore.case = TRUE) | 
                                      grepl('san francisco puc' , networkLocation , ignore.case = TRUE) , 'Internal City' , networkLocation) ,
                      SF = ifelse(cityId %in% idSF , userCount , 0) ,
                      Bay = ifelse(cityId %in% idBay , userCount , 0) ,
                      CA = ifelse(cityId %in% idCA , userCount , 0) ,
                      US = ifelse(cityId %in% idUS , userCount , 0) ,
                      NotUS = ifelse(cityId %in% idNotUS , userCount , 0) ,
                      NoCity = ifelse(cityId %in% idNone , userCount , 0) ,
                      LocationAll = rep(1 , length(SF)) 
                      )
data.master <- data.frame(dat , groupNetwork = groupNetwork(dat$networkLocation))

######################### same but for path

# now get creative with new/returning ...
rtnUsers.all.P <- subset(mutate(ga.data.all.P ,
                                rtnUsers = users - newUsers) ,
                         rtnUsers > 0) 
newUsers.all.P <- subset(ga.data.all.P , newUsers > 0)

rtn.all.P <- select(mutate(rtnUsers.all.P , 
                           userType = rep("Returning Visitor" , nrow(rtnUsers.all.P)) , 
                           userCount = rtnUsers) ,
                    date , networkLocation , deviceCategory , cityId , fullReferrer , landingPagePath , exitPagePath , 
                    users , newUsers , sessions , sessionDuration , goal1completions , goal2completions , Bounces , userType , userCount)
new.all.P <- mutate(newUsers.all.P , 
                    userType = rep("New Visitor" , nrow(newUsers.all.P)) , 
                    userCount = newUsers)

data.all.P <- mutate(rbind(rtn.all.P , new.all.P) ,
                     userGroup = 'All')

rtnUsers.dat.P <- subset(mutate(ga.data.dat.P ,
                                rtnUsers = users - newUsers) ,
                         rtnUsers > 0) 
newUsers.dat.P <- subset(ga.data.dat.P , newUsers > 0)


rtn.dat.P <- select(mutate(rtnUsers.dat.P , 
                           userType = rep("Returning Visitor" , nrow(rtnUsers.dat.P)) , 
                           userCount = rtnUsers) ,
                    date , networkLocation , deviceCategory , cityId , fullReferrer , landingPagePath , exitPagePath , 
                    users , newUsers , sessions , sessionDuration , goal1completions , goal2completions , Bounces , userType , userCount)
new.dat.P <- mutate(newUsers.dat.P , 
                    userType = rep("New Visitor" , nrow(newUsers.dat.P)) , 
                    userCount = newUsers)
data.dat.P <- mutate(rbind(rtn.dat.P , new.dat.P) ,
                     userGroup = 'DatasetUsers')


rtnUsers.eng.P <- subset(mutate(ga.data.eng.P ,
                                rtnUsers = users - newUsers) ,
                         rtnUsers > 0) 
newUsers.eng.P <- subset(ga.data.eng.P , newUsers > 0)


rtn.eng.P <- select(mutate(rtnUsers.eng.P , 
                           userType = rep("Returning Visitor" , nrow(rtnUsers.eng.P)) , 
                           userCount = rtnUsers) ,
                    date , networkLocation , deviceCategory , cityId , fullReferrer , landingPagePath , exitPagePath , 
                    users , newUsers , sessions , sessionDuration , goal1completions , goal2completions , Bounces , userType , userCount)
new.eng.P <- mutate(newUsers.eng.P , 
                    userType = rep("New Visitor" , nrow(newUsers.eng.P)) , 
                    userCount = newUsers)
data.eng.P <- mutate(rbind(rtn.eng.P , new.eng.P) ,
                     userGroup = 'engagedUsers')

rtnUsers.cpy.P <- subset(mutate(ga.data.cpy.P ,
                                rtnUsers = users - newUsers) ,
                         rtnUsers > 0) 
newUsers.cpy.P <- subset(ga.data.cpy.P , newUsers > 0)


rtn.cpy.P <- select(mutate(rtnUsers.cpy.P , 
                           userType = rep("Returning Visitor" , nrow(rtnUsers.cpy.P)) , 
                           userCount = rtnUsers) ,
                    date , networkLocation , deviceCategory , cityId , fullReferrer , landingPagePath , exitPagePath , 
                    users , newUsers , sessions , sessionDuration , goal1completions , goal2completions , Bounces , userType , userCount)
new.cpy.P <- mutate(newUsers.cpy.P , 
                    userType = rep("New Visitor" , nrow(newUsers.cpy.P)) , 
                    userCount = newUsers)
data.cpy.P <- mutate(rbind(rtn.cpy.P , new.cpy.P) ,
                     userGroup = 'copyUsers')

rtnUsers.dwn.P <- subset(mutate(ga.data.dwn.P ,
                                rtnUsers = users - newUsers) ,
                         rtnUsers > 0) 
newUsers.dwn.P <- subset(ga.data.dwn.P , newUsers > 0)


rtn.dwn.P <- select(mutate(rtnUsers.dwn.P , 
                           userType = rep("Returning Visitor" , nrow(rtnUsers.dwn.P)) , 
                           userCount = rtnUsers) ,
                    date , networkLocation , deviceCategory , cityId , fullReferrer , landingPagePath , exitPagePath , 
                    users , newUsers , sessions , sessionDuration , goal1completions , goal2completions , Bounces , userType , userCount)
new.dwn.P <- mutate(newUsers.dwn.P , 
                    userType = rep("New Visitor" , nrow(newUsers.dwn.P)) , 
                    userCount = newUsers)
data.dwn.P <- mutate(rbind(rtn.dwn.P , new.dwn.P) ,
                     userGroup = 'downloadUsers')


data.P <- mutate(rbind(data.all.P , data.dat.P , data.eng.P , data.cpy.P , data.dwn.P) ,
                        source = ifelse(grepl('ccsf' , networkLocation , ignore.case = TRUE) | 
                                          grepl('san francisco department of telecommunications and information s' , networkLocation , ignore.case = TRUE) | 
                                          grepl('san francisco public library'  , networkLocation , ignore.case = TRUE) | 
                                          grepl('san francisco international airport' , networkLocation , ignore.case = TRUE) | 
                                          grepl('san francisco puc' , networkLocation , ignore.case = TRUE) , 'Internal City' , networkLocation) ,
                        SF = ifelse(cityId %in% idSF , userCount , 0) ,
                        Bay = ifelse(cityId %in% idBay , userCount , 0) ,
                        CA = ifelse(cityId %in% idCA , userCount , 0) ,
                        US = ifelse(cityId %in% idUS , userCount , 0) ,
                        NotUS = ifelse(cityId %in% idNotUS , userCount , 0) ,
                        NoCity = ifelse(cityId %in% idNone , userCount , 0)  ,
                        LocationAll = rep(1 , length(SF)) 
)

data.master.P <- data.frame(data.P , groupNetwork = groupNetwork(data.P$networkLocation))

######################### same but for engagement

# now get creative with new/returning ...
rtnUsers.all.E <- subset(mutate(ga.data.all.E ,
                              rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.all.E <- subset(ga.data.all.E , newUsers > 0)

rtn.all.E <- select(mutate(rtnUsers.all.E , 
                         userType = rep("Returning Visitor" , nrow(rtnUsers.all.E)) , 
                         userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , eventCategory , eventAction ,
                  eventLabel , users , newUsers , sessions , sessionDuration , userType , userCount)
new.all.E <- mutate(newUsers.all.E , 
                  userType = rep("New Visitor" , nrow(newUsers.all.E)) , 
                  userCount = newUsers)

data.all.E <- mutate(rbind(rtn.all.E , new.all.E) ,
                   userGroup = 'All')

rtnUsers.dat.E <- subset(mutate(ga.data.dat.E ,
                              rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.dat.E <- subset(ga.data.dat.E , newUsers > 0)


rtn.dat.E <- select(mutate(rtnUsers.dat.E , 
                         userType = rep("Returning Visitor" , nrow(rtnUsers.dat.E)) , 
                         userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , eventCategory , eventAction ,
                  eventLabel , users , newUsers , sessions , sessionDuration , userType , userCount)
new.dat.E <- mutate(newUsers.dat.E , 
                  userType = rep("New Visitor" , nrow(newUsers.dat.E)) , 
                  userCount = newUsers)
data.dat.E <- mutate(rbind(rtn.dat.E , new.dat.E) ,
                   userGroup = 'DatasetUsers')


rtnUsers.eng.E <- subset(mutate(ga.data.eng.E ,
                              rtnUsers = users - newUsers) ,
                       rtnUsers > 0) 
newUsers.eng.E <- subset(ga.data.eng.E , newUsers > 0)


rtn.eng.E <- select(mutate(rtnUsers.eng.E , 
                         userType = rep("Returning Visitor" , nrow(rtnUsers.eng.E)) , 
                         userCount = rtnUsers) ,
                  date , networkLocation , deviceCategory , cityId , eventCategory , eventAction ,
                  eventLabel , users , newUsers , sessions , sessionDuration , userType , userCount)
new.eng.E <- mutate(newUsers.eng.E , 
                  userType = rep("New Visitor" , nrow(newUsers.eng.E)) , 
                  userCount = newUsers)
data.eng.E <- mutate(rbind(rtn.eng.E , new.eng.E) ,
                   userGroup = 'engagedUsers')

rtnUsers.cpy.E <- subset(mutate(ga.data.cpy.E ,
                                rtnUsers = users - newUsers) ,
                         rtnUsers > 0) 
newUsers.cpy.E <- subset(ga.data.cpy.E , newUsers > 0)


rtn.cpy.E <- select(mutate(rtnUsers.cpy.E , 
                           userType = rep("Returning Visitor" , nrow(rtnUsers.cpy.E)) , 
                           userCount = rtnUsers) ,
                    date , networkLocation , deviceCategory , cityId , eventCategory , eventAction ,
                    eventLabel , users , newUsers , sessions , sessionDuration , userType , userCount)
new.cpy.E <- mutate(newUsers.cpy.E , 
                    userType = rep("New Visitor" , nrow(newUsers.cpy.E)) , 
                    userCount = newUsers)
data.cpy.E <- mutate(rbind(rtn.cpy.E , new.cpy.E) ,
                     userGroup = 'copyUsers')

rtnUsers.dwn.E <- subset(mutate(ga.data.dwn.E ,
                                rtnUsers = users - newUsers) ,
                         rtnUsers > 0) 
newUsers.dwn.E <- subset(ga.data.dwn.E , newUsers > 0)


rtn.dwn.E <- select(mutate(rtnUsers.dwn.E , 
                           userType = rep("Returning Visitor" , nrow(rtnUsers.dwn.E)) , 
                           userCount = rtnUsers) ,
                    date , networkLocation , deviceCategory , cityId , eventCategory , eventAction ,
                    eventLabel , users , newUsers , sessions , sessionDuration , userType , userCount)
new.dwn.E <- mutate(newUsers.dwn.E , 
                    userType = rep("New Visitor" , nrow(newUsers.dwn.E)) , 
                    userCount = newUsers)
data.dwn.E <- mutate(rbind(rtn.dwn.E , new.dwn.E) ,
                     userGroup = 'downloadUsers')


data.E <- mutate(rbind(data.all.E , data.dat.E , data.eng.E , data.cpy.E , data.dwn.E) ,
                      source = ifelse(grepl('ccsf' , networkLocation , ignore.case = TRUE) | 
                                        grepl('san francisco department of telecommunications and information s' , networkLocation , ignore.case = TRUE) | 
                                        grepl('san francisco public library'  , networkLocation , ignore.case = TRUE) | 
                                        grepl('san francisco international airport' , networkLocation , ignore.case = TRUE) | 
                                        grepl('san francisco puc' , networkLocation , ignore.case = TRUE) , 'Internal City' , networkLocation) ,
                      SF = ifelse(cityId %in% idSF , userCount , 0) ,
                      Bay = ifelse(cityId %in% idBay , userCount , 0) ,
                      CA = ifelse(cityId %in% idCA , userCount , 0) ,
                      US = ifelse(cityId %in% idUS , userCount , 0) ,
                      NotUS = ifelse(cityId %in% idNotUS , userCount , 0) ,
                      NoCity = ifelse(cityId %in% idNone , userCount , 0) ,
                      LocationAll = rep(1 , length(SF)) 
)

data.master.E <- data.frame(data.E , groupNetwork = groupNetwork(data.E$networkLocation))

###############################
require("RPostgreSQL")
pw <- {
  'shinyapp'
}

drv <- dbDriver('PostgreSQL')

con <- dbConnect(drv , dbname = 'shiny' , 
                 host = '162.243.137.94' , port = 5432 ,
                 user = 'shiny' , password = pw)

dbListTables(con)

formatStartDate <- strftime(as.Date(start_date) , format = "%Y%m%d")
formatYesterday <- strftime(as.Date(yesterday) , format = "%Y%m%d")


# Remove recent last 2 days from DB
deleteSyntax <- paste("DELETE FROM data_master WHERE date IN ('" , formatStartDate , "' ,'" , formatYesterday , "')" , sep ='')

dbExecute(con,
          paste(deleteSyntax))

deleteSyntax.E <- paste("DELETE FROM data_master_E WHERE date IN ('" , formatStartDate , "' ,'" , formatYesterday , "')" , sep ='')

dbExecute(con,
          paste(deleteSyntax.E))

deleteSyntax.P <- paste("DELETE FROM data_master_P WHERE date IN ('" , formatStartDate , "' ,'" , formatYesterday , "')" , sep ='')

dbExecute(con,
          paste(deleteSyntax.P))


# Insert last 2 days to DB
valueSyntax <- NULL
for(i in 1:nrow(data.master)){
valueSyntax[i] <- paste("('" , paste(data.master$date[i] , data.master$networkLocation[i] , data.master$deviceCategory[i] , data.master$cityId[i] , data.master$users[i] ,
                    data.master$newUsers[i] , data.master$sessions[i] , data.master$sessionDuration[i] , data.master$goal1completions[i] ,
                    data.master$goal2completions[i] , data.master$Bounces[i] , data.master$userType[i] , data.master$userCount[i] , data.master$userGroup[i] ,
                    data.master$source[i] , data.master$SF[i] , data.master$Bay[i] , data.master$CA[i] , data.master$US[i] , data.master$NotUS[i] , 
                    data.master$NoCity[i] , data.master$LocationAll[i] , data.master$groupNetwork[i] , sep = "','") , 
                    "')" , sep = "")
}

valueSyntaxCollapse <- NULL
for(i in 1:nrow(data.master)){
  if(i != nrow(data.master)) {
  valueSyntaxCollapse <- c(paste(valueSyntaxCollapse , valueSyntax[i] , "," , sep = ""))
  } else{
    valueSyntaxCollapse <- c(paste(valueSyntaxCollapse , valueSyntax[i] , sep = ""))
  }
}

insertSyntax1 <- paste("INSERT INTO data_master " , "(" , "date,", "networkLocation,", "deviceCategory," ,"cityId,","users,","newUsers,","sessions,","sessionDuration,","goal1completions,","goal2completions,","Bounces,","userType,","userCount,","userGroup,","source,","SF,","Bay,","CA,","US,","NotUS,","NoCity,","LocationAll,","groupNetwork" ,")" , sep ="")
insertSyntax2 <- paste("VALUES " , valueSyntaxCollapse , sep = "")

dbExecute(con,
          paste(insertSyntax1 , insertSyntax2))

# now engagement
valueSyntaxE <- NULL
for(i in 1:nrow(data.master.E)){
  valueSyntaxE[i] <- paste("('" , paste(data.master.E$date[i] , data.master.E$networkLocation[i] , data.master.E$deviceCategory[i] , data.master.E$cityId[i] , data.master.E$eventCategory[i] ,
                                       data.master.E$eventAction[i] , gsub("'", '', data.master.E$eventLabel[i]) , data.master.E$users[i] , data.master.E$newUsers[i] ,
                                       data.master.E$sessions[i] , data.master.E$sessionDuration[i] , data.master.E$userType[i] , data.master.E$userCount[i] , data.master.E$userGroup[i] ,
                                       data.master.E$source[i] , data.master.E$SF[i] , data.master.E$Bay[i] , data.master.E$CA[i] , data.master.E$US[i] , data.master.E$NotUS[i] , 
                                       data.master.E$NoCity[i] , data.master.E$LocationAll[i] , data.master.E$groupNetwork[i] , sep = "','") , 
                          "')" , sep = "")
}

valueSyntaxCollapseE <- NULL
for(i in 1:nrow(data.master.E)){
  if(i != nrow(data.master.E)) {
    valueSyntaxCollapseE <- c(paste(valueSyntaxCollapseE , valueSyntaxE[i] , "," , sep = ""))
  } else{
    valueSyntaxCollapseE <- c(paste(valueSyntaxCollapseE , valueSyntaxE[i] , sep = ""))
  }
}

insertSyntax1.E <- paste("INSERT INTO data_master_e " , "(" , "date,", "networkLocation,", "deviceCategory," ,"cityId,","eventCategory,","eventAction,","eventLabel,","users,","newUsers,","sessions,","sessionDuration,","userType,","userCount,","userGroup,","source,","SF,","Bay,","CA,","US,","NotUS,","NoCity,","LocationAll,","groupNetwork" ,")" , sep ="")
insertSyntax2.E <- paste("VALUES " , valueSyntaxCollapseE , sep = "")

dbExecute(con,
          paste(insertSyntax1.E , insertSyntax2.E))

### Now refferal, landing/exit
valueSyntaxP <- NULL
for(i in 1:nrow(data.master.P)){
  valueSyntaxP[i] <- paste("('" , paste(data.master.P$date[i] , data.master.P$networkLocation[i] , data.master.P$deviceCategory[i] , data.master.P$cityId[i] , gsub("'","",data.master.P$fullReferrer[i]) ,
                                        gsub("'","",data.master.P$landingPagePath[i]) , gsub("'","",data.master.P$exitPagePath[i]) , data.master.P$users[i] , data.master.P$newUsers[i] ,
                                        data.master.P$sessions[i] , data.master.P$sessionDuration[i] , data.master.P$goal1completions[i] , data.master.P$goal2completions[i] , 
                                        data.master.P$Bounces[i] , data.master.P$userType[i] , data.master.P$userCount[i] , data.master.P$userGroup[i] ,
                                        data.master.P$source[i] , data.master.P$SF[i] , data.master.P$Bay[i] , data.master.P$CA[i] , data.master.P$US[i] , data.master.P$NotUS[i] , 
                                        data.master.P$NoCity[i] , data.master.P$LocationAll[i] , data.master.P$groupNetwork[i] , sep = "','") , 
                           "')" , sep = "")
}

valueSyntaxCollapseP <- NULL
for(i in 1:nrow(data.master.P)){
  if(i != nrow(data.master.P)) {
    valueSyntaxCollapseP <- c(paste(valueSyntaxCollapseP , valueSyntaxP[i] , "," , sep = ""))
  } else{
    valueSyntaxCollapseP <- c(paste(valueSyntaxCollapseP , valueSyntaxP[i] , sep = ""))
  }
}

insertSyntax1.P <- paste("INSERT INTO data_master_p " , "(" , "date,", "networkLocation,", "deviceCategory," ,"cityId,","fullReferrer,","landingPagePath,","exitPagePath,","users,","newUsers,","sessions,","sessionDuration,","goal1completions,","goal2completions,","Bounces,","userType,","userCount,","userGroup,","source,","SF,","Bay,","CA,","US,","NotUS,","NoCity,","LocationAll,","groupNetwork" ,")" , sep ="")
insertSyntax2.P <- paste("VALUES " , valueSyntaxCollapseP , sep = "")

dbExecute(con,
          paste(insertSyntax1.P , insertSyntax2.P))

####################################

data.master.new <- dbReadTable(con , 'data_master')
data.master.E.new <- dbReadTable(con , 'data_master_e')
data.master.P.new <- dbReadTable(con , 'data_master_p')

saveRDS(data.master.new , 'C:/Users/khicks/Documents/GAshinyApp/gaOpenData/data/data.master.rds')
saveRDS(data.master.E.new , 'C:/Users/khicks/Documents/GAshinyApp/gaOpenData/data/data.master.E.rds')
saveRDS(data.master.P.new , 'C:/Users/khicks/Documents/GAshinyApp/gaOpenData/data/data.master.P.rds')


