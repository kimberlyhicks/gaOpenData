source("data/LoadGA.R")

library(shiny)
library(plotly)
library(dplyr)
library(lubridate)
library(DT)
library(d3Tree)



shinyServer(function(input, output) {
  
  
# Take my data from google analytics and make format changes to dates
  
  data <- mutate(ga.mush,
                # date_fmt = ymd(date),
                 useDate = ymd(date) )
  
  data.cat <- mutate(data.all.events,
                     # date_fmt = ymd(date),
                     useDate = ymd(date) )
  
  
  output$tree <- renderD3tree({
    if(is.null(input$city) ) {
      datatreeInput <-  subset(data.cat,
                              source == input$Source &
                                userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    } else{datatreeInput <-  subset(data.cat,
                                   source == input$Source &
                                     userType %in% c(input$userType) &
                                     useDate >= input$dates[1] & 
                                     useDate <= input$dates[2] &
                                     city %in% c(input$city))
    }
    
    
    tree_data <- d3tree(list(root = df2tree(struct = summarise(group_by(datatreeInput , eventCategory , eventAction , eventLabel) ,
                                                               frequency = sum(users)) ,
                                            rootname = 'events'),
                             layout = 'collapse'))
  })
  
  
  # For output, define what the inputs are
  output$plot <- renderPlotly({
  
if(is.null(input$city) ) {
       datasetInput <-  subset(data,
                           source == input$Source &
                           userType %in% c(input$userType) &
                           useDate >= input$dates[1] & 
                           useDate <= input$dates[2] &
                           engagementEvent == input$engagementEvent)
    } else{datasetInput <-  subset(data,
                               source == input$Source &
                                 userType %in% c(input$userType) &
                                 useDate >= input$dates[1] & 
                                 useDate <= input$dates[2] &
                                 engagementEvent == input$engagementEvent &
                                 city %in% c(input$city))
}
    
 # Format the axis 
  a <- list(
    tickmode = 'auto',
    nticks = 5,
    title = ""
  )
  # Generate bar graph
  plot_ly(data = datasetInput , x = ~useDate, y = ~users) %>%
          layout(xaxis = a, yaxis = list(title = 'User Count') , barmode = 'stack') %>%
          add_trace(data = datasetInput, x = ~useDate, y = ~users, color = ~userType, type = "bar")
  #layout(xaxis = a, yaxis = a , barmode = 'stack' , hovermode = 'y') %>%
  #  add_trace(data = datasetInput, x = ~useDate, y = ~users, color = ~userType, type = "bar")    
  })
  
  output$hist <- renderPlotly({
  
  if(is.null(input$city) ) {
      dataeventInput <-  subset(data,
                              source == input$Source &
                                userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2] &
                                engagementEvent == input$engagementEvent)
    } else{dataeventInput <-  subset(data,
                                   source == input$Source &
                                     userType %in% c(input$userType) &
                                     useDate >= input$dates[1] & 
                                     useDate <= input$dates[2] &
                                     engagementEvent == input$engagementEvent &
                                     city %in% c(input$city))
    }
    
    session_new0 <- subset(dataeventInput, userType == 'New Visitor')[ , 'avgSessionDuration'] / 60
    session_rtn0 <- subset(dataeventInput, userType == 'Returning Visitor')[ , 'avgSessionDuration'] / 60
   
  # cutoff at 98%  
    cutoff <- quantile(c(session_new0 , session_rtn0) , .98)

  
    
    session_new <- ifelse(session_new0 > cutoff , cutoff , session_new0)
    session_rtn <- ifelse(session_rtn0 > cutoff , cutoff , session_rtn0)
    
    dens_new <- density(session_new)
    dens_rtn <- density(session_rtn)
    
    # Format the axis 
    a <- list(
      tickmode = 'auto',
      nticks = 5,
      title = "Minutes Per Session"
    )
    b <- list(
      tickmode = 'auto',
      nticks = 5,
      title = "Density"
    )
    
      plot_ly(alpha = 0.6 , x = ~dens_new$x , y = ~dens_new$y , type = "bar" , name = "New Visitors") %>%
     #   add_trace(x = perc_new , y = session_new , xaxis = a, yaxis = a, type = 'bar' , orientation = 'h')
        #add_histogram(x = ~session_new , name = "density") %>%
        add_trace(x = ~dens_rtn$x , y = ~dens_rtn$y , name = "Returning Visitors")  %>%
        layout(barmode = "overlay" , xaxis = a , yaxis = b)
  })
  
  # More info when hovering provided below plot.
 # output$event <- renderPrint({
  #   d <- event_data("plotly_hover")
  #  if(is.null(d)) "Hover on a point!" else d
  #  })
  
  output$table <- 
    
    renderDataTable({
      engagementSelection <- ifelse(is.null(input$engagementEvent) , '<Overall Baseline>' , input$engagementEvent)
      
if(is.null(input$city) ) {
        datalistInput <-  subset(data,
                                source == input$Source &
                                  userType %in% c(input$userType) &
                                  useDate >= input$dates[1] & 
                                  useDate <= input$dates[2]  &
                                  engagementEvent == input$engagementEvent)
      } else{datalistInput <-  subset(data,
                                     source == input$Source &
                                       userType %in% c(input$userType) &
                                       useDate >= input$dates[1] & 
                                       useDate <= input$dates[2] &
                                       city %in% c(input$city)  &
                                       engagementEvent == input$engagementEvent)
}
      TotalUsers <- as.numeric(subset(summarise(group_by(datalistInput , engagementEvent) ,
                                  Total_Users = sum(users)) ,
                                  engagementEvent == '<Overall Baseline>')[ , 'Total_Users']) 
    datatable(summarise(group_by(datalistInput , engagementEvent) ,
                                      UserCount = sum(users) ,
                                      UserPercentage = sum(users) / TotalUsers ,
                                      SessionsPerUser = sum(sessions) / sum(users) ,
                                      AvgSessionDuration = sum(avgSessionDuration * users) / sum(users) / 60
                                    ) ) %>%
        formatPercentage('UserPercentage' , 2) %>%
        formatCurrency('UserCount' , currency = "" , digits = 0 , mark =",") %>%
        formatRound('SessionsPerUser' , digits = 2) %>%
        formatRound('AvgSessionDuration' , digits = 2)
    }) 
     # options = list(
    #    order = list(list(2, 'asc')) ,
    #     formatPercentage('UserPercentage' , 2)
    #    ) 
    
  
  
})