source("data/LoadGA.R")

library(shiny)
library(plotly)
library(dplyr)
library(lubridate)


shinyServer(function(input, output) {
  
# Take my data from google analytics and make format changes to dates
  
  data <- mutate(ga.mush,
                # date_fmt = ymd(date),
                 useDate = ymd(date) )
  
  
  # For output, define what the inputs are
  output$plot <- renderPlotly({
    datasetInput <- subset(data,
                           source == input$Source &
                           userType %in% c(input$userType) &
                           useDate >= input$dates[1] & 
                           useDate <= input$dates[2] )
    
 # Format the axis 
  a <- list(
    tickmode = 'auto',
    nticks = 5,
    title = ""
  )
  # Generate bar graph
  plot_ly(data = datasetInput) %>%
          layout(xaxis = a, yaxis = a , barmode = 'stack') %>%
          add_trace(data = datasetInput, x = ~useDate, y = ~users, color = ~eventCategory, type = "bar")
      })
  
  # More info when hovering provided below plot.
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if(is.null(d)) "Hover on a point!" else d
  })
  
  output$table <- 
    
    renderDataTable({
      datasetInput <- subset(data,
                             source == input$Source &
                               userType %in% c(input$userType) &
                               useDate >= input$dates[1] & 
                               useDate <= input$dates[2] )
      loc_data <- summarise(group_by(datasetInput , country , city) ,
                            Total_Users = sum(users))
      loc_data
    })
  
  
})