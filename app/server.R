shinyServer(function(input, output) {
  # 2. map tab
  output$map <- renderLeaflet({
    # default map, base layer
    m <- leaflet(nyc_neighborhoods) %>%
      addTiles() %>% 
      addProviderTiles("CartoDB.Positron") %>%
      setView(-73.983,40.7639,zoom = 10) %>% 
      addPolygons(popup = ~ntaname,
                  fillColor = "gray", 
                  fillOpacity = 1, 
                  weight = 2, 
                  stroke = T, 
                  color = "green", 
                  opacity = 1) 
    
  })
  # Overview:
  ##checkbox for heatmap
  observeEvent(input$click_heatmap,{
    ## when the box is checked, show the heatmap 
    if(input$click_heatmap ==TRUE) leafletProxy("map")%>%
      addPolygons(data = nyc_neighborhoods,
                  popup = ~ntaname,
                  stroke = T, weight=1,
                  fillOpacity = 0.95,
                  color = ~pal(treeCountsGroupedByZipCode$value),
                  highlightOptions = highlightOptions(color='#ff0000', opacity = 0.5, weight = 4, fillOpacity = 0.9,bringToFront = TRUE),
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"),
                  group = "number_of_trees")%>%
      ## the legend of color
      addLegend(pal = pal,group = "number_of_trees", values = treeCountsGroupedByZipCode$value, opacity = 1) %>% showGroup("number_of_trees")
    ## when the box is unchecked, show the base map
    else{leafletProxy("map") %>% hideGroup("number_of_trees") %>% clearControls()}
  })
  ## species: 
  spe <- reactive({
    data %>% filter(spc == input$type) %>% select(zip,lat,lng) %>%
      mutate(zip = as.character(zip)) %>% 
      group_by(zip) %>% summarise(value = n()) %>% left_join(zipcode) %>% select(-c("city","state"))
  })
  observeEvent(input$type,{
    leafletProxy("map") %>%
      clearGroup("type")
    leafletProxy("map") %>% 
      addMarkers(data = spe(),group = "type",icon = list(iconUrl = "icon/tree.png",iconSize=c(15,15)))
  })
  
  ## heatmap for problem: issue of color and controls
  observeEvent(input$enable_heatmap,{
    
    if("Root Problem" %in% input$enable_heatmap) leafletProxy("map") %>% 
      addPolygons(data = nyc_neighborhoods,
                  popup = ~ntaname,
                  stroke = T, weight=1,
                  fillOpacity = 0.95,
                  color = ~pal_root(markers_root$value),
                  highlightOptions = highlightOptions(color='#ff0000', opacity = 0.5, weight = 4, fillOpacity = 0.9,bringToFront = TRUE),
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"),
                  group = "root")%>%
      ## the legend of color
      addLegend(pal = pal_root,group = "root", values = markers_root$value, opacity = 1) %>% showGroup("root")
    ## when the box is unchecked, show the base map
    else{leafletProxy("map") %>% hideGroup("root") %>% clearControls()}
    
    if("Branch Problem" %in% input$enable_heatmap) leafletProxy("map") %>%
      addPolygons(data = nyc_neighborhoods,
                  popup = ~ntaname,
                  stroke = T, weight=1,
                  fillOpacity = 0.95,
                  color = ~pal_branch(markers_branch$value),
                  highlightOptions = highlightOptions(color='#ff0000', opacity = 0.5, weight = 4, fillOpacity = 0.9,bringToFront = TRUE),
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"),
                  group = "branch")%>%
      ## the legend of color
      addLegend(pal = pal_branch,group = "branch", values = markers_branch$value, opacity = 1) %>% showGroup("branch")
    ## when the box is unchecked, show the base map
    else{leafletProxy("map") %>% hideGroup("branch") %>% clearControls()}
    
    if("Trunk Problem" %in% input$enable_heatmap) leafletProxy("map")%>% 
      addPolygons(data = nyc_neighborhoods,
                  popup = ~ntaname,
                  stroke = T, weight=1,
                  fillOpacity = 0.95,
                  color = ~pal_trunk(markers_trunk$value),
                  highlightOptions = highlightOptions(color='#ff0000', opacity = 0.5, weight = 4, fillOpacity = 0.9,bringToFront = TRUE),
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"),
                  group = "trunk")%>%
      ## the legend of color
      addLegend(pal = pal_trunk,group = "trunk", values = markers_root$value, opacity = 1) %>% showGroup("trunk")
    ## when the box is unchecked, show the base map
    else{leafletProxy("map") %>% hideGroup("trunk") %>% clearControls()}
  })
  
  
  
  
  observeEvent(input$zipcode,{
    if (nchar(input$zipcode) != 0) leafletProxy("map") %>% 
      clearGroup("number_of_trees") %>% 
      clearGroup("type") %>% 
      clearGroup("root") %>% 
      clearGroup("branch") %>% 
      clearGroup("trunk")
  })
  
  #By ZIPCODE:
  ## problem
  observeEvent(input$enable_markers, {
    if("Root Problem" %in% input$enable_markers) leafletProxy("map",
                                                              data = problem %>% filter(root == 1) %>% 
                                                                select(zipcode,lat,lng) %>%
                                                                mutate(zip = as.character(zipcode)) %>% filter(zip==input$zipcode)) %>% 
      addMarkers(lat = ~lat,lng = ~lng,
                 group ="markers_root",popup = "root problem",
                 icon = list(iconUrl = "icon/root.png",iconSize=c(15,15)))%>% showGroup("markers_root")
    else{leafletProxy("map") %>% hideGroup("markers_root")}
    
    if("Branch Problem" %in% input$enable_markers) leafletProxy("map",data = problem %>% filter(branch == 1) %>% 
                                                                  select(zipcode,lat,lng) %>%
                                                                  mutate(zip = as.character(zipcode)) %>% filter(zip==input$zipcode)) %>% 
      addMarkers(lat = ~lat,lng = ~lng,
                 group ="markers_branch",popup = "branch problem",
                 icon = list(iconUrl = "icon/branch.png",iconSize=c(15,15)))%>% showGroup("markers_branch")
    else{leafletProxy("map") %>% hideGroup("markers_branch")}
    
    if("Trunk Problem" %in% input$enable_markers) leafletProxy("map",data = problem %>% filter(trunk == 1) %>% 
                                                                 select(zipcode,lat,lng) %>%
                                                                 mutate(zip = as.character(zipcode)) %>% filter(zip==input$zipcode)) %>% 
      addMarkers(lat = ~lat,lng = ~lng,
                 group ="markers_trunk",popup = "trunk problem",
                 icon = list(iconUrl = "icon/trunk.png",iconSize=c(15,15)))%>% showGroup("markers_trunk")
    
    else{leafletProxy("map") %>% hideGroup("markers_trunk")}
    
  })
  
  
  # Output Panel
  output$ziparea = renderText(paste("Zipcode: ",input$zipcode))
  output$total = renderText(paste("Number of trees in this zip: ",
                                  nrow(data[data$zip==(as.numeric(input$zipcode)),])))
  
  output$spc_pie = renderPlotly({
    df1 = data[data$zip==as.numeric(input$zipcode),]
    a1 = aggregate(df1$tree_id,list(df1$spc),length)
    col1 = rainbow(nrow(a1))
    plot_ly(labels=a1[,1],values=a1[,2], type = "pie",
            marker=list(colors=col1),textinfo = "none") %>%
      layout(title = paste("Species propotion"),showlegend=F,
             xaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F),
             yaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F))
  })
  
  output$health_pie = renderPlotly({
    df1 = data[data$zip==as.numeric(input$zipcode),]
    a1 = aggregate(df1$tree_id,list(df1$health),length)
    col1 = rainbow(nrow(a1))
    plot_ly(labels=a1[,1], values=a1[,2], type = "pie",
            marker=list(colors=col1)) %>%
      layout(title = paste("Health propotion"),showlegend=F,
             xaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F),
             yaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F))
  })
  
  output$guard_pie = renderPlotly({
    df1 = data[data$zip==as.numeric(input$zipcode),]
    a1 = aggregate(df1$tree_id,list(df1$guard),length)
    col1 = rainbow(nrow(a1))
    plot_ly(labels=a1[,1], values=a1[,2], type = "pie",
            marker=list(colors=col1)) %>%
      layout(title = paste("Guard propotion"),showlegend=F,
             xaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F),
             yaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F))
  })
  
  output$sidewalk_pie = renderPlotly({
    df1 = data[data$zip==as.numeric(input$zipcode),]
    a1 = aggregate(df1$tree_id,list(df1$side),length)
    col1 = rainbow(nrow(a1))
    plot_ly(labels=a1[,1], values=a1[,2], type = "pie",
            marker=list(colors=col1)) %>%
      layout(title = paste("Sidewalk propotion"),showlegend=F,
             xaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F),
             yaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F))
  })
  
  output$table = renderDataTable(tree, options = list(pageLength = 10, lengthMenu = list(c(10))))
  
  
})

