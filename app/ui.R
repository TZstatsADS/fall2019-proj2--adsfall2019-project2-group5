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
                                  h5(strong("Tree Coverage:")),
                                  checkboxInput("click_heatmap","heat map",value = FALSE),
                                  # select the species
                                  selectInput("type", label = "Species of tree:",
                                              choices = append(as.character(unique(data$spc)),"None",0),selected = NULL,multiple = FALSE
                                  ),
                                  # check the problem
                                  radioButtons("enable_heatmap", "Tree problem heatmap:",
                                                     choices = list("Root Problem","Trunk Problem","Branch Problem"),
                                               selected = character(0)
                                  ),
                                  
                                  #By Zipcode
                                  h3("By ZIPCODE"),
                                  # select the zipcode
                                  h4("Step 1"),
                                  selectInput("zipcode", label = "Please select the ZIPCODE :", 
                                              choices =  c("None",sort(as.numeric(unique(tree_zip$zip)))),selected = NULL,multiple = FALSE
                                  ),
                                  h5("Pie Charts are shown on the right."),
                                  div(),
                                  h4("Step 2"),
                                  checkboxGroupInput("enable_markers", "Add Markers for:",
                                                     choices = c("Root Problem","Trunk Problem","Branch Problem")
                                  )
                    ),
                    
                    # Output Panel
                    absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                  top = 120, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                                  #overview of trees coverage of NYC
                                  h3("Outputs"),
                                  #By Zipcode
                                  h4("By ZIPCODE"),
                                  #By Zipcode
                                  p(textOutput("ziparea")),
                                  p(textOutput("total")),
                                  plotlyOutput("spc_pie", height="180"),
                                  plotlyOutput("health_pie",height = "180"),
                                  plotlyOutput("guard_pie",height = "180"),
                                  plotlyOutput("sidewalk_pie",height = "180")
                                 
                    )              
                )
            ),
            # 3. Comparison tab
            tabPanel("Comparison",
                     div(class = "outer2",
                         leafletOutput("map1",width = "100%", height = "1000px"),
                         absolutePanel(id = "controls",class = "panel panel-default", 
                                       fixed = TRUE, draggable = TRUE,
                                       top = 120, left = 20, right = "auto", bottom = "auto", 
                                       width = 250, height = "auto",
                                       
                                       #overview of trees coverage of NYC
                                       h3("Tree Coverage:"),
                                       h4(strong("Please select both Regions and Year.")),
                                       radioButtons("enable_regions", "Regions:",
                                                          choices = c("Neighbourhoods","Boroughs"),
                                                    selected = character(0)
                                       ),
                                       radioButtons("comparison_heatmap", "Year:",
                                                    choices = list("2005","2015"),
                                                    selected = character(0)
                                       )
                                     
                         )
                     )       
              
            ),
            # 5. Next Steps / Future Ideas
            tabPanel("Next Steps / Future Ideas",
                     mainPanel
                     (
                       width = 12,
                       h3("Predictive Model for Trees"),
                       p("If, for a prior years tree data set, we can find the tree ID associated with a specific tree in the prior years and most recent year, we can track that trees health over time. If we have information on the tree, such as whether it was located on a sidewalk or whether it had branch/trunk/root problems, we may be able to make a predictive model to estimate which trees have a high likellihood of dying and thus prevent future deaths by taking the necessary precautions."),
                       br(),
                       h3("Analyzing Trees after Grouping By Similarities"),
                       p("The tree data gives us information about what species each tree is from. We can use this information to create another column called 'Category'. In this column, we will put tree species in the same category if they are similar to each other based on certain criteria. This will require using the Internet and other resources to figure out which trees should be grouped together. After this is done, we can create a map that shows were trees within the same category are planted. This would allow for a more interesting and detailed map view.")
                       
                     ),
                     # footer
                     div(class = "footer","Applied Data Science")
            ),
            # 4. Data tab
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

