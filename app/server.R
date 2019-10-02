#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(data.table)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    # 2. map tab
    output$map <- renderLeaflet({
        # default map, base layer
        m <- leaflet() %>% 
            addProviderTiles(providers$CartoDB.Positron) %>% 
            setView(-73.983,40.7639,zoom = 13) 
    
    })
    
})