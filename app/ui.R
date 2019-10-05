shinyUI(

    div(id = "canvas",
        navbarPage(strong("2015 Street Trees Census",style = "color:green"),
                   theme = "style.css",
            # 1. Intro tab
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
                    leafletOutput("map",width = "100%", height = "1000px"),
                    
                    # Control Panel
                    absolutePanel(id = "controls",class = "panel panel-default", 
                                  fixed = TRUE, draggable = TRUE,
                                  top = 120, left = 20, right = "auto", bottom = "auto", 
                                  width = 250, height = "auto",
                                  selectInput("type", label = "Species of tree:", 
                                              choices = unique(data$spc)
                                             ),
                                  checkboxGroupInput("enable_markers", "Add Markers for:",
                                                     choices = c("Root Problem","Trunk Problem","Branch Problem"),
                                                     selected = c("Root Problem","Trunk Problem","Branch Problem")
                                                     )
                    ),
                    # footer
                    div(class = "footer","Applied Data Science")
                    
                   
        ),
            # 3. Interesting Findings tab
            tabPanel("Interesting Findings"
        ),
            # 4. Data tab
            tabPanel("Data"
        )
    )
    
)))
