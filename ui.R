
library(shiny)
library(plotly)
library(dplyr)
library(lubridate)


shinyUI(fluidPage(
  # Application title
  titlePanel("Users"),
  
  # Sidebar with widgets
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dates" , 
                   label = h3("Date range") , 
                   start = ymd('20170301') , end = ymd('20170401')),
      checkboxGroupInput("userType" ,
                   label = h3("User Type"),
                   choices = list("New" = 'New Visitor' , "Returning" = 'Returning Visitor') ,
                   selected = c('New Visitor' , 'Returning Visitor')) ,
      radioButtons("Source" ,
                   label = h3("Internal/External"),
                   choices = list("All" = 'All' , "Internal" = 'Internal' , "External" = 'External')) 
     # Table detailing location.
     , dataTableOutput("table")
    ),
    
    # Show a plot of the generated data
    mainPanel(
      plotlyOutput("plot"),
      verbatimTextOutput("event") 
      
    )
  )
))