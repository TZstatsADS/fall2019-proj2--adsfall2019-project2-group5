
tree <- read.csv("tree.csv",header = TRUE)

data <- tree %>% select(c("status","health","spc_common",
                          "steward","guards","sidewalk",
                          "address","zipcode","zip_city",
                          "boroname","Latitude","longitude"))
# trees count by region
count_df <- data %>% 
  filter(zipcode>0) %>% 
  mutate(region = as.character(zipcode)) %>% 
  group_by(region) %>% summarise(value = n())

head(count_df)

if (!require("choroplethr")) install.packages("choroplethr")
if (!require("devtools")) install.packages("devtools")


# a simple plot of trees count by region
library(devtools)

if (!require("choroplethrZip")) 
  devtools::install_github('arilamstein/choroplethrZip@v1.5.0')

library(choroplethrZip)
zip_choropleth(count_df,
               title       = "2015 Street Trees Census",
               legend      = "Number of trees",
               county_zoom = 36061)

# problem data set
problem <- tree 





