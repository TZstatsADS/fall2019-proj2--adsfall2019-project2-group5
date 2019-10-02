
tree <- read.csv("tree.csv",header = TRUE)
tree <- tree %>% select(c("status","health","spc_common",
                          "steward","guards","sidewalk",
                          "address","zipcode","zip_city","boroname","Latitude","longitude"))

problem <- tree %>% 

count_df <- tree %>% 
  filter(zipcode>0) %>% 
  mutate(region = as.character(zipcode)) %>% 
  group_by(region) %>% summarise(value = n())

if (!require("choroplethr")) install.packages("choroplethr")
if (!require("devtools")) install.packages("devtools")

library(devtools)

if (!require("choroplethrZip")) 
  devtools::install_github('arilamstein/choroplethrZip@v1.5.0')

if (!require("ggplot2")) devtools::install_github("hadley/ggplot2")
if (!require("ggmap")) devtools::install_github("dkahle/ggmap")

library(choroplethrZip)
zip_choropleth(count_df,
               title       = "2015 Street Trees Census",
               legend      = "Number of trees",
               county_zoom = 36061)

