library(dplyr)
library(leaflet)
library(leaflet.extras)
library(sp)
library(maptools)
library(broom)
library(httr)
library(rgdal)
library(zipcode)

# original data
tree <- read.csv("tree.csv",header = TRUE)
# change the name of latitute and longitute
colnames(tree)[39:40] <- c("lat","lng")
# delete the unreasonable zipcde
tree_data <- tree[tree$zipcode !=83,]
# select the variables we may need and save it as tree_data
tree_data <- tree_data %>% select(c("status","health","spc_common",
                          "steward","guards","sidewalk",
                          "address","zipcode","zip_city",
                          "boroname","root_stone","root_grate","root_other",
                          "trnk_wire","trnk_light","trnk_other",
                          "brnch_ligh","brnch_shoe","brnch_othe","lat","lng"))

# species data save it as data
load("~/Google Drive (zz2587@columbia.edu)/Map/tree_data.RData")
colnames(data)[4:5] = c("lat","lng")
data = data[data$zip != 83,]
e = data$spc[631]
data = data[data$spc != e,]   ## remove empty values
data = data[order(data$spc),] ## order the spc names  


# Base map
## Shapefiles for adding polygons of regions in NYC
nyc_neighborhoods <- readOGR("NYCNeighborhood.geojson","NYCNeighborhood")


# Heatmap: Tree coverage dataset 
treeCountsGroupedByZipCode <- tree_data %>% group_by(zipcode) %>% tally()
treeCountsGroupedByZipCode <- as.data.frame(treeCountsGroupedByZipCode)
colnames(treeCountsGroupedByZipCode) <- c("ZIPCODE", "value")
# Heatmap: for coloring
pal <- colorNumeric(
  palette = "Reds",
  domain = treeCountsGroupedByZipCode$value)


# problem data set save it as problem
problem <- tree_data %>% 
  select(c("zipcode","root_stone","root_grate","root_other",
           "trnk_wire","trnk_light","trnk_other",
           "brnch_ligh","brnch_shoe","brnch_othe",
           "lat","lng")) %>% 
  mutate(root = ifelse(root_stone == "Yes",1,
                       ifelse(root_grate =="Yes",1,
                              ifelse(root_other =="Yes",1,0))),
         trunk = ifelse(trnk_wire == "Yes",1,
                        ifelse(trnk_light =="Yes",1,
                               ifelse(trnk_other =="Yes",1,0))),
         branch = ifelse(brnch_ligh == "Yes",1,
                         ifelse(brnch_shoe =="Yes",1,
                                ifelse(brnch_othe =="Yes",1,0))))

# find zipcode data that have the lat, log of each zipcode
data("zipcode")

# problem: root data
markers_root <- problem %>% filter(root == 1) %>% 
  select(zipcode,lat,lng) %>%
  mutate(zip = as.character(zipcode)) %>% 
  group_by(zip) %>% summarise(value = n()) %>% left_join(zipcode) %>% select(-c("city","state"))
# problem: trunk data
markers_trunk <- problem %>% filter(trunk == 1) %>% 
  select(zipcode,lat,lng) %>%
  mutate(zip = as.character(zipcode)) %>% 
  group_by(zip) %>% summarise(value = n()) %>% left_join(zipcode) %>% select(-c("city","state"))
# problem: branch data
markers_branch <- problem %>% filter(branch == 1) %>% 
  select(zipcode,lat,lng) %>%
  mutate(zip = as.character(zipcode)) %>% 
  group_by(zip) %>% summarise(value = n()) %>% left_join(zipcode) %>% select(-c("city","state"))




## TEST
type = "honeylocust" 
text = "10024"

tree_data %>% filter(spc_common == type,zipcode ==text) %>% select(lat,lng) %>%
  mutate(zip = as.character(zip)) %>% 
  group_by(zip) %>%  filter(zip == text)%>% left_join(zipcode) %>% select(-c("city","state"))


#m <- leaflet() %>% 
 # addProviderTiles(providers$CartoDB.Positron) %>% 
  #setView(-73.983,40.7639,zoom = 13) 

# a simple plot of trees count by region for reference
#library(devtools)

#if (!require("choroplethrZip")) 
  #devtools::install_github('arilamstein/choroplethrZip@v1.5.0')

#library(choroplethrZip)
#zip_choropleth(count_df,
              # title       = "2015 Street Trees Census",
              # legend      = "Number of trees",
              # county_zoom = 36061)
# trees count by region
#count_df <- data %>% 
 # filter(zipcode>0) %>% 
 # mutate(region = as.character(zipcode)) %>% 
# group_by(region) %>% summarise(value = n())

#head(count_df)

#if (!require("choroplethr")) install.packages("choroplethr")
#if (!require("devtools")) install.packages("devtools")


