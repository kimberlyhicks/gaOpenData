################################################
# Server script

shinyServer(function(input, output ,session) {

  # Ensure data is reactive to widgets.
  dataINPUT <- reactive({
    
    if(is.null(input$source)) {
      
      datasetInput <-  subset(data,
                                userGroup == input$behaviorGroup &
                                deviceCategory %in% c(input$device) &
                                groupNetwork %in% c(input$sourceGroup) &
                                userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    }  else{
      
          datasetInput <-  subset(data,
                                   # city == input$city &
                                    deviceCategory %in% c(input$device) &
                                    groupNetwork %in% c(input$sourceGroup) &
                                    source == input$source &
                                    userGroup == input$behaviorGroup &
                                    userType %in% c(input$userType) &
                                    useDate >= input$dates[1] & 
                                    useDate <= input$dates[2])
        }
  })
  
  # Histogram requires slightly different reactive data input.
  dataINPUT.H <- reactive({
    
    if(is.null(input$source)) {
      
      datasetInput <-  subset(data,
                                userGroup == input$behaviorGroup &
                                deviceCategory %in% c(input$device) &
                                groupNetwork %in% c(input$sourceGroup) &
                                #userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    }  else{
      
      datasetInput <-  subset(data,
                              #  city == input$city &
                                deviceCategory %in% c(input$device) &
                                groupNetwork %in% c(input$sourceGroup) &
                                source == input$source &
                                userGroup == input$behaviorGroup &
                                #userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    }
  })
  
  # Reactive data for engagement tab.
  dataINPUT.E <- reactive({
   
    if(is.null(input$source)) {
      datasetInput <-  subset(data.E,
                                userGroup == input$behaviorGroup &
                                deviceCategory %in% c(input$device) &
                                groupNetwork %in% c(input$sourceGroup) &
                                userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    }  else{
      datasetInput <-  subset(data.E,
                               # city == input$city &
                                deviceCategory %in% c(input$device) &
                                groupNetwork %in% c(input$sourceGroup) &
                                source == input$source &
                                userGroup == input$behaviorGroup &
                                userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    }
  })
  
  # Reactive data for referral/landing/exit tab.
  dataINPUT.P <- reactive({
    
    if(is.null(input$source)) {
      datasetInput <-  subset(data.P,
                                userGroup == input$behaviorGroup &
                                deviceCategory %in% c(input$device) &
                                groupNetwork %in% c(input$sourceGroup) &
                                userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    }  else{
      datasetInput <-  subset(data.P,
                             #   city == input$city &
                                deviceCategory %in% c(input$device) &
                                groupNetwork %in% c(input$sourceGroup) &
                                source == input$source &
                                userGroup == input$behaviorGroup &
                                userType %in% c(input$userType) &
                                useDate >= input$dates[1] & 
                                useDate <= input$dates[2])
    }
  })
  
  # Bar chart breakout for type of engagement for engaged panel.
  output$barEngage <- renderPlotly({
    
    datasetInput <- dataINPUT.E()
    
    totalEngage <- sum(datasetInput$userCount)
    
    sumEngage <- summarise(group_by(datasetInput, eventCategory) ,
                            userSum = sum(userCount) ,
                            userPct = paste(round(sum(userCount) / totalEngage , 3) * 100 , "%" , sep = "")
    )
    
    # Rank event categories and reorder
    rankEngage <- frank(sumEngage , 'userSum' , ties.method = 'first')
    matchTopEngage <- max( 0 , max(rankEngage) - 10):max(rankEngage)
    topEngage <- sumEngage[which(rankEngage %in% matchTopEngage) , ]
    topEngageOrder <- topEngage[order(topEngage$userSum , decreasing = FALSE) , ]
    
    # Text to add to graph and where to add it
    y <- topEngageOrder$eventCategory
    text <- topEngageOrder$userPct
    buff <- totalEngage * .1
    x <-  topEngageOrder$userSum + buff
    
    # Axis options to include
    ax <- list(
      type = "category",
      categoryorder = "array",
      categoryarray = topEngageOrder$eventCategory,
      autorange = TRUE,
      showticklabels = TRUE,
      ticks = "outside" ,
      title = ""
    )

    # Margin options to include    
    mm <- list(
      l = 150,
      r = 0,
      b = 100,
      t = 0,
      pad = 4
    )
    
    # Generate bar graph
    plot_ly(data = topEngageOrder , y = ~eventCategory, x = ~userSum , type = 'bar' , orientation = 'h' , color=I('#d95f0e') , opacity = .75) %>%
      layout(yaxis = ax, xaxis = list(title = 'Sum Engagement Events'), margin = mm) %>%
      add_annotations(text = text,
                      x = x,
                      y = y,
                      font = list(family = 'Arial',
                                  size = 14,
                                  color = I('#636363')),
                      showarrow = FALSE)
    
  })
  
  # Bar graph for top network groups for engaged panel.
  output$barNetwork <- renderPlotly({
    
    datasetInput <- dataINPUT()
    
    totalEngage <- sum(datasetInput$userCount)
    
    sumEngage <- summarise(group_by(datasetInput, groupNetwork) ,
                           userSum = sum(userCount) ,
                           userPct = paste(round(sum(userCount) / totalEngage , 3) * 100 , "%" , sep = "")
    )
    
    # Rank group networks and reorder
  #  rankEngage <- frank(sumEngage , 'userSum' , ties.method = 'first')
  #  matchTopEngage <- max( 0 , max(rankEngage) - 10):max(rankEngage)
  #  topEngage <- sumEngage[which(rankEngage %in% matchTopEngage) , ]
    topEngageOrder <- sumEngage[order(sumEngage$userSum , decreasing = FALSE) , ]
    
    # Text to add to graph and where to add it
    y <- topEngageOrder$groupNetwork
    text <- topEngageOrder$userPct
    buff <- totalEngage * .1
    x <-  topEngageOrder$userSum + buff
    
    # Axis options
    ax <- list(
      type = "category",
      categoryorder = "array",
      categoryarray = topEngageOrder$groupNetwork,
      autorange = TRUE,
      showticklabels = TRUE,
      ticks = "outside" ,
      title = ""
    )

    # Margin options    
    mm <- list(
      l = 150,
      r = 0,
      b = 100,
      t = 0,
      pad = 4
    )
    
    # Generate bar graph
    plot_ly(data = topEngageOrder , y = ~groupNetwork, x = ~userSum , type = 'bar' , orientation = 'h' , color=I('#d95f0e') , opacity = .75) %>%
      layout(yaxis = ax, xaxis = list(title = 'Unique Daily Users'), margin = mm) %>%
      add_annotations(text = text,
                      x = x,
                      y = y,
                      font = list(family = 'Arial',
                                  size = 14,
                                  color = I('#636363')),
                      showarrow = FALSE)
    
  })
  
   
  # Bar plot for device category for engaged data set.
  output$barDevice <- renderPlotly({
    
    datasetInput <- dataINPUT()
    
    totalEngage <- sum(datasetInput$userCount)
    
    sumEngage <- summarise(group_by(datasetInput, deviceCategory) ,
                           userSum = sum(userCount) ,
                           userPct = paste(round(sum(userCount) / totalEngage , 3) * 100 , "%" , sep = "")
    )
    
    # Rank by device category and reorder
    rankEngage <- frank(sumEngage , 'userSum' , ties.method = 'first')
    matchTopEngage <- max( 0 , max(rankEngage) - 10):max(rankEngage)
    topEngage <- sumEngage[which(rankEngage %in% matchTopEngage) , ]
    topEngageOrder <- topEngage[order(topEngage$userSum , decreasing = FALSE) , ]
    
    # Text to add to graph and where to add it
    y <- topEngageOrder$deviceCategory
    text <- topEngageOrder$userPct
    buff <- totalEngage * .1
    x <-  topEngageOrder$userSum + buff
    
    # Axis options
    ax <- list(
      type = "category",
      categoryorder = "array",
      categoryarray = topEngageOrder$deviceCategory,
      autorange = TRUE,
      showticklabels = TRUE,
      ticks = "outside" ,
      title = ""
    )
    
    # Margin options
    mm <- list(
      l = 150,
      r = 0,
      b = 100,
      t = 0,
      pad = 4
    )
    
    # Table of engagement detail
    output$table <- 
      
      renderDataTable({
        datasetInput <- dataINPUT.E()
        sumRef <- summarise(group_by (datasetInput , eventCategory , eventAction , eventLabel) ,
                            userCount = sum(userCount))
        #rankRef <- frank(sumRef , 'userCount' , ties.method = 'first')
        #matchTopRef <- max( 0 , max(rankRef) - 10):max(rankRef)
        #topRef <- sumRef[which(rankRef %in% matchTopRef) , ]
        topRefOrder <- sumRef[order(sumRef$userCount , decreasing = TRUE) , ]
        topRefOrder
      }, options = list(lengthMenu = c(10, 20, 50), pageLength = 10))
    
    
    # Generate bar graph
    plot_ly(data = topEngageOrder , y = ~deviceCategory, x = ~userSum , type = 'bar' , orientation = 'h' , color=I('#d95f0e') , opacity = .75) %>%
      layout(yaxis = ax, xaxis = list(title = 'Unique Daily Users'), margin = mm) %>%
      add_annotations(text = text,
                      x = x,
                      y = y,
                      #   xref = "x",
                      #  yref = "y",
                      font = list(family = 'Arial',
                                  size = 14,
                                  color = I('#636363')),
                      showarrow = FALSE)
    
  })
  
  
  # Text to display at top of general panel.
  output$text1 <- renderText({
    datasetInput <- dataINPUT()
    bounceRate = round(sum(datasetInput$Bounces) / sum(datasetInput$sessions) , digits = 3) * 100
    paste(bounceRate , '%' , sep='')
  }) 
  output$text2 <- renderText({
    datasetInput <- dataINPUT()
    avgSessionsPerDay = round(sum(datasetInput$sessions) / length(unique(datasetInput$date)) , digits = 0)
    paste(avgSessionsPerDay)
  }) 
  output$text3 <- renderText({
    datasetInput <- dataINPUT()
    avgUsersPerDay = round(sum(datasetInput$userCount) / length(unique(datasetInput$date)) , digits = 0)
    paste(avgUsersPerDay)
  }) 
  output$text4 <- renderText({
    datasetInput <- dataINPUT()
    pctNew = round(sum(subset(datasetInput,userType == 'New Visitor')$userCount) / sum(datasetInput$userCount) , digits = 3) * 100
    paste(pctNew , '%' , sep = '')
  }) 
  output$text5 <- renderText({
    datasetInput <- dataINPUT()
    avgTimePerSession = round(sum(datasetInput$sessionDuration) / sum(datasetInput$sessions) / 60 , digits = 1)
    paste(avgTimePerSession)
  }) 
  output$text6 <- renderText({
    datasetInput <- dataINPUT()
    pctMobile = sum(subset(datasetInput , deviceCategory == 'mobile')$userCount) / sum(datasetInput$userCount)
    pctMobileFmt = paste(round(pctMobile , 3) * 100 , "%" , sep="")
   paste(pctMobileFmt)
 }) 
 
  # Text to display at top of referral/landing/exit panel.
  output$text7 <- renderText({
    datasetInput <- dataINPUT()
    bounceRate = round(sum(datasetInput$Bounces) / sum(datasetInput$sessions) , digits = 3) * 100
    paste(bounceRate , '%' , sep='')
  }) 
  output$text8 <- renderText({
    datasetInput <- dataINPUT()
    avgSessionsPerDay = round(sum(datasetInput$sessions) / length(unique(datasetInput$date)) , digits = 0)
    paste(avgSessionsPerDay)
  }) 
  output$text9 <- renderText({
    datasetInput <- dataINPUT()
    avgUsersPerDay = round(sum(datasetInput$userCount) / length(unique(datasetInput$date)) , digits = 0)
    paste(avgUsersPerDay)
  }) 
  output$text10 <- renderText({
    datasetInput <- dataINPUT()
    pctNew = round(sum(subset(datasetInput,userType == 'New Visitor')$userCount) / sum(datasetInput$userCount) , digits = 3) * 100
    paste(pctNew , '%' , sep = '')
  }) 
  output$text11 <- renderText({
     datasetInput <- dataINPUT()
    avgTimePerSession = round(sum(datasetInput$sessionDuration) / sum(datasetInput$sessions) / 60 , digits = 1)
    paste(avgTimePerSession)
  }) 
  output$text12 <- renderText({
    datasetInput <- dataINPUT()
    pctMobile = sum(subset(datasetInput , deviceCategory == 'mobile')$userCount) / sum(datasetInput$userCount)
    pctMobileFmt = paste(round(pctMobile , 3) * 100 , "%" , sep="")
    paste(pctMobileFmt)
  }) 
 
  # Time plot of new/returning users on general panel.
  output$plot2 <- renderPlotly({
  
    datasetInput <- dataINPUT()
   
    # Format the axis 
    a <- list(
      tickmode = 'auto',
      nticks = 5,
      title = ""
     )
   
    typeData <- mutate(datasetInput ,
                      userCountNew = ifelse(userType == 'New Visitor' , userCount , 0) ,
                      userCountReturning = ifelse(userType == 'Returning Visitor' , userCount , 0)
                      )
   
    timeData <- summarise(group_by(typeData , useDate) ,
                         userCountNew = sum(userCountNew) ,
                         userCountReturning = sum(userCountReturning) ,
                         userSignups = sum(goal2completions)
                          )
   
   # Generate bar graph
   plot_ly(data = timeData) %>% 
     add_trace(x = ~useDate , y = ~userCountReturning, color = I('#9ebcda') , opacity = 0.85 , type = "bar" , name = 'Returning') %>%
     add_trace(x = ~useDate , y = ~userCountNew, color = I('#8856a7') , opacity = 0.85 , type = "bar" , name = 'New') %>%      
     layout(xaxis = a, 
            yaxis = list(title = 'Unique Daily Users') , 
            barmode = 'stack')
  })
 
  # Time plot of new/returning users on referral/landing/exit panel.
  output$plot <- renderPlotly({
  
    datasetInput <- dataINPUT()
    
  # Format the axis 
  a <- list(
      tickmode = 'auto',
      nticks = 5,
      title = ""
    )
  
    typeData <- mutate(datasetInput ,
                     userCountNew = ifelse(userType == 'New Visitor' , userCount , 0) ,
                     userCountReturning = ifelse(userType == 'Returning Visitor' , userCount , 0))
  
    timeData <- summarise(group_by(typeData , useDate) ,
                        userCountNew = sum(userCountNew) ,
                        userCountReturning = sum(userCountReturning) ,
                        userSignups = sum(goal2completions)
                        )
  
  # Generate bar graph
    plot_ly(data = timeData) %>% 
          add_trace(x = ~useDate , y = ~userCountReturning, color = I('#9ebcda') , opacity = 0.85 , type = "bar" , name = 'Returning') %>%
          add_trace(x = ~useDate , y = ~userCountNew, color = I('#8856a7') , opacity = 0.85 , type = "bar" , name = 'New') %>%      
          layout(xaxis = a, 
                 yaxis = list(title = 'Unique Daily Users') , 
                 barmode = 'stack')
    })
  
  # Create bar graph for group network on geneal panel.  
  output$barSource <- renderPlotly({
    
    datasetInput <- dataINPUT()
  
    totalSources <- sum(datasetInput$userCount)
    
    sumSources <- summarise(group_by(datasetInput, groupNetwork) ,
                         userSum = sum(userCount) ,
                         userPct = paste(round(sum(userCount) / totalSources , 3) * 100 , "%" , sep = "")
                         )
    
    # Rank group networks and reorder
    rankSources <- frank(sumSources , 'userSum' , ties.method = 'first')
    matchTopSources <- max( 0 , max(rankSources) - 10):max(rankSources)
    topSources <- sumSources[which(rankSources %in% matchTopSources) , ]
    topSourcesOrder <- topSources[order(topSources$userSum , decreasing = FALSE) , ]
  
    # Text for graph and where to put it
    y <- topSourcesOrder$groupNetwork
    text <- topSourcesOrder$userPct
    buff <- totalSources * .1
    x <-  topSourcesOrder$userSum + buff

    # Format axis  
    ax <- list(
      type = "category",
      categoryorder = "array",
      categoryarray = topSourcesOrder$groupNetwork,
      autorange = TRUE,
      showticklabels = TRUE,
      ticks = "outside" ,
      title = ""
    )
    
    # Format margin
    mm <- list(
      l = 150,
      r = 0,
      b = 100,
      t = 0,
      pad = 4
    )
    
    # Generate bar graph
    plot_ly(data = topSourcesOrder , y = ~groupNetwork, x = ~userSum , type = 'bar' , orientation = 'h' , color=I('#d95f0e') , opacity = .75) %>%
        layout(yaxis = ax, xaxis = list(title = 'Unique Daily Users'), margin = mm) %>%
        add_annotations(text = text,
                      x = x,
                      y = y,
                      font = list(family = 'Arial',
                                  size = 14,
                                  color = I('#636363')),
                      showarrow = FALSE)
    
     })
  
  # Table of network locations reordered by user count on general tab. 
  output$tableSource <- 
    
    renderDataTable({
        datasetInput <- dataINPUT()
        sumRef <- summarise(group_by (datasetInput , networkLocation) ,
                          userCount = sum(userCount))
        rankRef <- frank(sumRef , 'userCount' , ties.method = 'first')
        matchTopRef <- max( 0 , max(rankRef) - 10):max(rankRef)
        topRef <- sumRef[which(rankRef %in% matchTopRef) , ]
        topRefOrder <- topRef[order(topRef$userCount , decreasing = TRUE) , ]
        topRefOrder
    }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
  
  # Waterfall graph. 
  output$barCity <- renderPlotly({
    datasetInput <- dataINPUT()
      
    y <- c('Total', 'No ID' , 'Non US' , 'Total US' , 'Other US' , 'Total California' ,
           'Other California' , 'Total Bay Area', 'Other Bay Area' ,'SF')
    
    # Define nested variables       
    SF <- sum(datasetInput$SF)
    Bay <- sum(datasetInput$Bay)
    CA <- sum(datasetInput$CA)
    US <- sum(datasetInput$US)
    NotUS <- sum(datasetInput$NotUS)
    NoCity <- sum(datasetInput$NoCity)
    Total <- US + NotUS + NoCity
    
    # Prepare text for waterfall
    pSF <- paste(round(SF / Total , 3) * 100 , "%" , sep = "")
    pBayOther <- paste(round((Bay - SF) / Total , 3) * 100 , "%" , sep = "")
    pBay <- paste(round(Bay / Total , 3) * 100 , "%" , sep = "")
    pCAOther <- paste(round((CA - Bay) / Total , 3) * 100 , "%" , sep = "")
    pCA <- paste(round(CA / Total , 3) * 100 , "%" , sep = "")
    pUSOther <- paste(round((US - CA)/ Total , 3) * 100 , "%" , sep = "")
    pUS <- paste(round(US / Total , 3) * 100 , "%" , sep = "")
    pNotUS <- paste(round(NotUS / Total , 3) * 100 , "%" , sep = "")
    pNoCity <- paste(round(NoCity / Total , 3) * 100 , "%" , sep = "")
    pTotal <- paste(round(Total / Total , 3) * 100 , "%" , sep = "")
    
    # Text and where to put it
    buff <- Total * .1
    x <- c(Total + buff , Total + buff , Total - NoCity + buff , US + buff , US + buff , CA + buff , 
           CA + buff , Bay + buff , Bay + buff , SF + buff)
    text <- c(pTotal , pNoCity , pNotUS , pUS , pUSOther , pCA , pCAOther , pBay , pBayOther , pSF)
    
    # Bottom of bar
    base <- c(0, US + NotUS , US , 0 , CA , 0 , Bay , 0 , SF , 0)
    # Top of full bars
    revenue <- c(US + NotUS + NoCity, 0 , 0 , US , 0 , CA , 0 , Bay , 0 , SF)
    # Top of partial bars
    profit <- c(0, NoCity, NotUS , 0 , US - CA , 0, CA - Bay , 0 , Bay - SF , 0)
    
    data <- data.frame(y ,  base , revenue , profit)
    
    # Order by groupings defined as y above
    data$y <- factor(data$y, levels = data[["y"]])
    
    # Margin format
    mm <- list(
      l = 120,
      r = 0,
      b = 100,
      t = 0,
      pad = 4
    )
    
    # Actual waterfall graph
    p <- plot_ly(data, y = ~y, x = ~base, type = 'bar', orientation = 'h' , marker = list(color = 'rgba(1,1,1, 0.0)')) %>%
      add_trace(x = ~revenue, orientation = 'h' , marker = list(color = 'rgba(50, 171, 96, 0.7)',
                                            line = list(color = 'rgba(50, 171, 96, 1.0)',
                                            
                                                        width = 2))) %>%
      
      add_trace(x = ~profit,  orientation = 'h' ,marker = list(color = 'gray',
                                           line = list(color = 'gray',
                                                       width = 2))) %>%
      layout(orientation = 'h' , 
             xaxis = list(title = ""),
             yaxis = list(title = ""),
             barmode = 'stack',
             margin = mm ,
             showlegend = FALSE) %>%
      add_annotations(text = text,
                      x = x,
                      y = y,
                      font = list(family = 'Arial',
                                  size = 14,
                                  color = I('#636363')),
                      showarrow = FALSE)
    
      })
  
  # Histogram on general tab
  output$hist <- renderPlotly({
  
    datasetInput <- dataINPUT.H()
    
    session_new0 <- subset(datasetInput, userType == 'New Visitor')$sessionDuration / 60
    session_rtn0 <- subset(datasetInput, userType == 'Returning Visitor')$sessionDuration / 60
   
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

      plot_ly(alpha = 0.85 , x = ~dens_new$x , y = ~dens_new$y , type = "bar" , name = "New Visitors" , color = I('#8856a7')) %>%
        add_trace(x = ~dens_rtn$x , y = ~dens_rtn$y , name = "Returning Visitors" , color = I('#9ebcda'))  %>%
        layout(barmode = "overlay" , xaxis = a , yaxis = b) 
  })
  
  # Table for top referrers
  output$tableRef <- 
    
    renderDataTable({
      datasetInput <- dataINPUT.P()
      sumRef <- summarise(group_by (datasetInput , fullReferrer) ,
                                      userCount = sum(userCount))
      rankRef <- frank(sumRef , 'userCount' , ties.method = 'first')
      matchTopRef <- max( 0 , max(rankRef) - 10):max(rankRef)
      topRef <- sumRef[which(rankRef %in% matchTopRef) , ]
      topRefOrder <- topRef[order(topRef$userCount , decreasing = TRUE) , ]
      datatable(topRefOrder)
    })
  
  # Table for top landings
  output$tableLand <- 
    
    renderDataTable({
      datasetInput <- dataINPUT.P()
      sumLand <- summarise(group_by (datasetInput , landingPagePath) ,
                          userCount = sum(userCount))
      rankLand <- frank(sumLand , 'userCount' , ties.method = 'first')
      matchTopLand <- max( 0 , max(rankLand) - 10):max(rankLand)
      topLand <- sumLand[which(rankLand %in% matchTopLand) , ]
      topLandOrder <- topLand[order(topLand$userCount , decreasing = TRUE) , ]
      datatable(topLandOrder)
    })
  
  # Table for top exits
  output$tableExit <- 
    
    renderDataTable({
      datasetInput <- dataINPUT.P()
      sumExit <- summarise(group_by (datasetInput , exitPagePath) ,
                           userCount = sum(userCount))
      rankExit <- frank(sumExit , 'userCount' , ties.method = 'first')
      matchTopExit <- max( 0 , max(rankExit) - 10):max(rankExit)
      topExit <- sumExit[which(rankExit %in% matchTopExit) , ]
      topExitOrder <- topExit[order(topExit$userCount , decreasing = TRUE) , ]
      datatable(topExitOrder)
    })
  
})