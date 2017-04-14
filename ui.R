
library(shiny)
library(plotly)
library(dplyr)
library(lubridate)
library(DT)
library(d3Tree)



#cities_index <- order(unique(ga.mush[ , 'city']))
#SF_index <- which(unique(ga.mush[ , 'city']) == 'San Francisco')
#cities_dropdown <- unique(ga.mush[ , 'city'])[c(SF_index , cities_index[-(which(cities_index == SF_index))])]

shinyUI(fluidPage(
  # Application title
  titlePanel("SF OpenData Google Analytics"),
  
  # Sidebar with widgets
 
  sidebarLayout(
    sidebarPanel(
      
      dateRangeInput("dates" , 
                   label = h3("Date range") , 
                   start = ymd('20170301') , end = ymd('20170412')),
      
      checkboxGroupInput("userType" ,
                   label = h3("User Type"),
                   choices = list("New" = 'New Visitor' , "Returning" = 'Returning Visitor') ,
                   selected = c('New Visitor' , 'Returning Visitor')) ,
     
      radioButtons("Source" ,
                   label = h3("Internal/External"),
                   choices = list("All" = 'All' , "Internal" = 'Internal' , "External" = 'External')) ,
     radioButtons("engagementEvent" ,
                   label = h3("Engagement Event"),
                   choices = list("None selected" = "<Overall Baseline>" , "Copy Endpoint" = 'Copy Endpoint' , 
                                  "Data Panel" = 'Data Panel' , "Downloads" = 'Downloads' ,
                                  "Outbound Link" = 'Outbound Link' , "Video" = 'Video')) ,
     
               selectizeInput('city' , 
                     label = h3("City") , choices = list("San Francisco" = 'San Francisco') , multiple = T ,
                     options = list(
                      placeholder = 'Select city below')) 
     # Table detailing location.
     #, dataTableOutput("table")
    ) ,
    
    # Show a plot of the generated data
 mainPanel(
   fluidRow(  
        column (8 , 
                h2("User Count over Time: New/Returning") ,
                plotlyOutput("plot")
          #      verbatimTextOutput("event")
          ),
        column (4 , 
                h2("Minutes per Session: New/Returning") ,
                plotlyOutput("hist")) ,
      
    #  br() ,
      h2("Engagement Events") ,
        column (6 ,
                d3treeOutput('tree')) ,
        column (6 ,
                dataTableOutput("table")) 
      
      
      )
    )
))
)
