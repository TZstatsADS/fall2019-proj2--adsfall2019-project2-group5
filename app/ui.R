shinyUI(

    div(id = "canvas",
        navbarPage(strong("Street Trees Census",style = "color:green"),
                   theme = "styles.css",
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
                                  
                                  #overview of trees coverage of NYC
                                  h3("Overview"),
                                  h5("Tree Coverage:"),
                                  checkboxInput("click_heatmap","heat map",value = FALSE),
                                  # select the species
                                  selectInput("type", label = "Species of tree:", 
                                              choices = unique(data$spc),selected = NULL
                                  ),
                                  # check the problem
                                  radioButtons("enable_heatmap", "Tree problem heatmap:",
                                                     choices = list("Root Problem","Trunk Problem","Branch Problem"),
                                               selected = NULL
                                  ),
                                  
                                  #By Zipcode
                                  h3("By ZIPCODE"),
                                  # select the zipcode
                                  selectInput("zipcode", label = "Please select the ZIPCODE :", 
                                              choices = unique(tree_zip$zip),selected = NULL
                                  ),
                                  h5("Pie Charts are shown on the right."),
                                  checkboxGroupInput("enable_markers", "Step 2 Add Markers for:",
                                                     choices = c("Root Problem","Trunk Problem","Branch Problem")
                                  ),
                                  #By Year
                                  h3("By YEAR"),
                                  
                                  # check the year
                                  checkboxGroupInput("enable_year", "Year for:",
                                                     choices = c("2015","20xx"),
                                                     selected = c("2015")
                                                    )
                    ),
                    
                    # Output Panel
                    absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                  top = 120, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                                  #overview of trees coverage of NYC
                                  h2("Outputs"),
                                  #By Zipcode
                                  h3("By ZIPCODE"),
                                  #By Zipcode
                                  p(textOutput("ziparea")),
                                  p(textOutput("total")),
                                  plotlyOutput("spc_pie", height="150"),
                                  plotlyOutput("health_pie",height = "150"),
                                  plotlyOutput("guard_pie",height = "150"),
                                  plotlyOutput("sidewalk_pie",height = "150")
                                 
                    )              
                                  
                )
            ),
            # 3. Data tab
            tabPanel("Data",
                     
                     div(width = 12,
                         
                         h1("Tree Data (2015)"),
                         br(),
                         dataTableOutput('table')
                     ),
                     
                     div(class="footer", "Applied Data Science")
            )
        )
    )
)
