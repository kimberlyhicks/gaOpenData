############################
# UI Script

shinyUI(fluidPage(
  
  # Application title
  titlePanel("SF OpenData Google Analytics"),
  
  # Sidebar with widgets
  sidebarLayout(
    sidebarPanel(
      width = 2 ,

      dateRangeInput("dates" , 
                   label = h3("Date range") , 
                   start = ymd(as.Date(yesterday) - days(30)) , end = ymd(yesterday) ,
                   format = "m/d/yy"
                   ),
      
      checkboxGroupInput("userType" ,
                   label = h3("User Type"),
                   choices = list("New" = 'New Visitor' , "Returning" = 'Returning Visitor') ,
                   selected = c('New Visitor' , 'Returning Visitor')) ,
     
     radioButtons("behaviorGroup" ,
                   label = h3("Engagement Level"),
                    choices = list("All" = "All" , "Dataset Users" = 'DatasetUsers' , 
                              #     "Signed Up Users" = 'signupUsers' ,
                                   "Engaged Users" = 'engagedUsers' , 
                                   "Engaged: Download dataset" = 'downloadUsers' , 
                                   "Engaged: Copy Endpoint" = 'copyUsers')) ,
     
     selectizeInput("source" ,
                    label = h3("Network location"),
                    choices = unique(data[ , 'networkLocation']) , multiple = T ,
                    options = list(
                      placeholder = 'Select source below')) ,
     checkboxGroupInput("sourceGroup" ,
                        label = h3("Network group"),
                        choices = list("Internal" = 'Internal City' , 
                                       "Local Media" = 'Local Media' ,
                                       "Local University" = 'Local University' ,
                                       "Other Education" = 'Other Education' ,
                                       "Private Companies" = 'Private Companies' ,
                                       "Research/Govt" = 'Research ,Govt' ,
                                       "Generic Internet" = 'Generic Internet' ,
                                       "Other" = 'Other') ,
                        selected = c('Internal City' , 'Local Media' , 'Local University' ,
                                     'Other Education' , 'Private Companies' ,
                                     'Research ,Govt' , 'Generic Internet' , 'Other')) ,     
     checkboxGroupInput("device" ,
                        label = h3("Device"),
                        choices = list("Desktop" = 'desktop' , "Tablet" = 'tablet' , "Mobile" = 'mobile') ,
                        selected = c('desktop' , 'tablet' , 'mobile')) 
     # Table detailing location.
     #, dataTableOutput("table")
    ) ,
    
    # Show a plot of the generated data
  mainPanel(
    tabsetPanel(
      tabPanel("General" ,
        fluidRow(
          hr(),
          column(2 ,
            h4('Bounce rate'),
            h2(textOutput("text1"))),
          column(2 ,
            h4('Avg Ssn/Day'),
            h2(textOutput("text2"))),
          column(2 ,
            h4('Avg Usr/Day'),
            h2(textOutput("text3"))),
          column(2 ,
            h4('% New'),
            h2(textOutput("text4"))),
          column(2 ,
            h4('Avg Min/Ssn'),
            h2(textOutput("text5"))) ,
          column(2 , 
            h4('% Mobile'),
            h2(textOutput("text6")))
       ),
        fluidRow(
          hr(),     
          column (8 , 
            h3("User Count over Time") ,
            plotlyOutput("plot")
          ),
          column (4 , 
            h3("Minutes per Session") ,
            plotlyOutput("hist")) ,
          column (4 , 
            h3("Location: % of Unique Daily Users") ,
            plotlyOutput("barCity")) ,
          column (4 , 
            h3("Network group") ,
            plotlyOutput("barSource")) ,
          column (4 , 
            h3("Network locations") ,
            div(DT::dataTableOutput("tableSource"), style = "font-size: 75%; width: 75%"))
          )
       ),
      
      tabPanel('Engagement' ,
        fluidRow(
          column(4 , 
            h4('Engagement group: % of Engaged Users') ,
            plotlyOutput("barEngage")),
          column(4 , 
            h4('Network group: % of Engaged Users') ,
            plotlyOutput("barNetwork")),
          column(4 ,    
            h4('Device: % of Engaged Users') ,
            plotlyOutput("barDevice"))
            ),
        fluidRow(
          column (width = 11 ,
            h4('Engagement Event Detail') ,
            dataTableOutput("table"))
        )       
      ) ,
      
      tabPanel('Refferal-Landing-Exit' ,
        fluidRow(
          hr(),
          column(2 ,
            h4('Bounce rate'),
            h2(textOutput("text7"))),
          column(2 ,
            h4('Avg Ssn/Day'),
            h2(textOutput("text8"))),
          column(2 ,
            h4('Avg Usr/Day'),
            h2(textOutput("text9"))),
          column(2 ,
            h4('% New'),
            h2(textOutput("text10"))),
          column(2 ,
            h4('Avg Min/Ssn'),
            h2(textOutput("text11"))) ,
          column(2 , 
            h4('% Mobile'),
            h2(textOutput("text12")))
        ) ,
        fluidRow(
          hr(),
          column (8 , 
            h3("User Count over Time") ,
            plotlyOutput("plot2" )) 
        ) ,
        fluidRow(
          column(4 ,
            h4('Top Referral Pages') ,
            div(DT::dataTableOutput("tableRef"), 
                style = "font-size: 75%; width: 75%")) ,
          column(4 ,
            h4('Top Landing Pages') ,
            div(DT::dataTableOutput("tableLand"), style = "font-size: 75%; width: 75%")) ,
          column(4 ,
            h4('Top Exit Pages') ,
            div(DT::dataTableOutput("tableExit"), style = "font-size: 75%; width: 75%")) )
        )
      )
    )
))
)


