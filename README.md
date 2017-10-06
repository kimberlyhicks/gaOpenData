# Google analytics shiny app

Inspired by WPRDC's shiny app, DataSF decided to create our own public facing dashboard of our Google Analytics Data.

Description of files in repo:

ui.R --> Shiny app layout + aesthetics. Placement of widgets, graphs, tables and tab display as well of text content and sizing.

server.R --> Computations and functions that build your app as defined in ui.R. By design, Shiny apps should be reactive to changes made in the widgets. To achieve this reactivity, you must use a render function tied to an object defined in ui.R with the relevant expressions wrapped in {} . Following this R tutorial https://shiny.rstudio.com/tutorial/lesson1/ will help you get started.

global.R --> Variables and libraries to be used in both ui.R and server.R. 

LoadGA.R --> Script to be run daily to get latest GA data, put it in database and update Shiny data. This script sources 2 files:
1. networkGroup.R --> Function to create grouping variable for networkLocation. This is a custom function which is only relevant to our networkLocation results.
2. token_file.R --> client ID and client Secret that allow connection to GA. You will need to create your own. Instructions can be found at https://cran.r-project.org/web/packages/RGA/vignettes/authorize.html .

This script executes many queries because GA limits the number of dimensions to be called per query to 7. It then runs these queries identically over two segments pre-defined within Google Analytics. General instructions for setting up the queries, building them out and executing against your token can be found here: 

After performing the querying, there is quite a bit of code to standardize structure and create new variables. The results are then put into our database and, ultimately, resaved as RDS files for Shiny to access.

In order to run app in RStudio: create new project, choose Version Control and paste clone from repository. As noted above, you will need to create your own GA authenticity token.
