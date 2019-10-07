library(dplyr)
library(leaflet)
library(leaflet.extras)
library(sp)
library(maptools)
library(broom)
library(httr)
library(rgdal)
library(zipcode)
library(plotly)

# original data
load("~/Desktop/fall2019-proj2--adsfall2019-project2-group5-master/app/tree.RData")
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
tree_data2 = tree_data %>% select(c("status","health","spc_common",
                                    "steward","guards","sidewalk",
                                    "zipcode","zip_city",
                                    "boroname","lat","lng"))

# species data save it as data
load("~/Desktop/fall2019-proj2--adsfall2019-project2-group5-master/app/tree_data.RData")
data$health = tree$health
data$guard = tree$guards
data$side = tree$sidewalk
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


# find zipcode data that have the lat, log of each zipcode
data("zipcode")
tree_zip <- tree_data %>% select(zipcode) %>% mutate(zip = as.character(zipcode))

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

# Heatmap: for coloring
pal <- colorNumeric(
  palette = "Reds",
  domain = treeCountsGroupedByZipCode$value)
pal_root <- colorNumeric(
  palette = "Blues",
  domain = markers_root$value)
pal_branch <- colorNumeric(
  palette = "Oranges",
  domain = markers_branch$value)
pal_trunk <- colorNumeric(
  palette = "Purples",
  domain = markers_trunk$value)




