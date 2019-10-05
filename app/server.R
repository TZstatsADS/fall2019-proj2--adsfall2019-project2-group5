
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
        
          
        leafletProxy("map",data = markers_root) %>% 
            addMarkers(lat = ~latitude,lng = ~longitude,
                       group ="markers_root",popup = "root problem",
                       icon = list(iconUrl = "icon/root.png",iconSize=c(15,15)))
        
        leafletProxy("map",data = markers_branch) %>% 
            addMarkers(lat = ~latitude,lng = ~longitude,
                       group ="markers_branch",popup = "branch problem",
                       icon = list(iconUrl = "icon/branch.png",iconSize=c(15,15)))
        
        leafletProxy("map",data = markers_trunk) %>% 
            addMarkers(lat = ~latitude,lng = ~longitude,
                       group ="markers_trunk",popup = "trunk problem",
                       icon = list(iconUrl = "icon/trunk.png",iconSize=c(15,15)))
        m
        })
    # species: cannot remove marker for unselected species
    spe <- reactive({
        data %>% filter(spc == input$type) %>% select(zip,lat,lng) %>%
            mutate(zip = as.character(zip)) %>% 
            group_by(zip) %>% summarise(value = n()) %>% left_join(zipcode) %>% select(-c("city","state"))
    })
    # problem:
    observeEvent(input$enable_markers, {
        if("Root Problem" %in% input$enable_markers) leafletProxy("map") %>% showGroup("markers_root")
        else{leafletProxy("map") %>% hideGroup("markers_root")}
        if("Branch Problem" %in% input$enable_markers) leafletProxy("map") %>% showGroup("markers_branch")
        else{leafletProxy("map") %>% hideGroup("markers_branch")}
        if("Trunk Problem" %in% input$enable_markers) leafletProxy("map") %>% showGroup("markers_trunk")
        else{leafletProxy("map") %>% hideGroup("markers_trunk")}
    
    }, ignoreNULL = FALSE)
    observeEvent(input$type,{
        leafletProxy("map") %>% 
            addMarkers(data = spe(),popup=~as.character(zip),icon = list(iconUrl = "icon/tree.png",iconSize=c(15,15)))
    })
    
})