#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(data.table)
library(plotly)




if (!require("choroplethrZip")) {
    # install.packages("devtools")
    library(devtools)
    install_github('arilamstein/choroplethrZip@v1.5.0')}


# Define UI for application that draws a histogram
shinyUI(

    div(id = "canvas",
        navbarPage(strong("2015 Street Trees Census",style = "color:green"),
                   theme = "style.css",
            # 1. INTRO tab
            tabPanel("Introduction",
                mainPanel(width = 12,
                    h1("Hello World!")
                                
                                
                            ),
                # footer
                div(class = "footer","Applied Data Science")
        ),
            
            # 2. MAP tab
            tabPanel("Map",
                div(class = "outer",
                    # leaflet map
                    leafletOutput("map",width = "100%", height = "1000px"))
                   
        ),
            # 3. Interesting Findings tab
            tabPanel("Interesting Findings"
        ),
            # 4. Data tab
            tabPanel("Data"
        )
    )
    
))
