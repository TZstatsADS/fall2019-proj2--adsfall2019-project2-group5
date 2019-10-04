library(shiny)
library(maps)
library(magrittr)
library(leaflet)  ## import package

load('../proj2/data/tree_data.RData')
colnames(data)[4:5] = c("lat","lng")
data = data[data$zip != 83,]
e = data$spc[631]
data = data[data$spc != e,]   ## remove empty values
data = data[order(data$spc),] ## order the spc names  

## part1
icons = list(iconUrl='tree.png',iconSize=c(15,15))   ## define icon
leaflet()%>%setView(-73.98928,40.75042,zoom = 12)%>%
  addTiles()%>%addProviderTiles("Stamen.TonerLite")  ## set base map
input = "honeylocust"         ## assume input is honeylocust
df = data[data$spc==input,]
area = unique(df$zip)
df2 = NULL
for (i in area){
  df2 = rbind(df2,df[(df$zip==i),][1,])
}
df2%>%leaflet()%>%addTiles()%>% addMarkers(popup=~as.character(zip),icon = icons)
## represent which areas contain such spc

## part2
input = 10024
df = data[data$zip==input,]
nspc = length(unique(df$spc))
a = aggregate(df$tree_id,list(df$spc),length)
col = rainbow(nrow(a))
pie(a[,2],paste(a[,1],round(100 * a[,2] / sum(a[,2]),2),"%"),col=col,
    main = paste("Total numbers of trees: ",nrow(df)))
## create pie chart of spc propotion in certain area

## input code for ui part
##  selectInput("type",
## "spc of tree:",
##   choices = unique(data$spc)


