## NYC Street Trees Information App
![screenshot](doc/nyc-street-trees.jpg)

+ Term: Fall 2019 Team #5

+ Team members:
	+ Chai, Nyu @nc2774
	+ Gu, Feichi @feichigu
	+ Mathew, Jess @jessmathew
	+ Zhou, Zian @zzzaaannn
	
+ **Background**:
Trees are vital. They give us oxygen, store carbon and give life to whole world's wildlife. People are attracted to live and work in surroundings. Companies benefit from a healthier and happier workforce if there are parks and trees nearby. Therefore, parks and trees would become an more vital component of urban life. People must respect them and protect them for the future.

+ **Dataset**: 
The datasets our group used are '2015 Street Tree Census - Tree Data' from open NYC
(https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/pi5s-9p35). 
And'2005 Street Tree Census' (https://data.cityofnewyork.us/Environment/2005-Street-Tree-Census/29bw-z7pjThis) Those datasets include tree species, diameter and perception of health.

+ **Plan**: 

+ -Obtain datasets we need 

+ -Select features we interest that can show comparisions between different zipcode

+ -Process data and visualize data

+ -Update the code to our shiny app we need

+ **Project summary** :
Our project analyzes and visualizes street trees information regarding health and illness conditions for different species of trees in New York City. The tree data were obtained from NYC Open Data portal. Our group also compared street tree's distribution in NYC betweem year 2005 and year 2015.We created an app to assist users to explore in four main tabs: Maps, comparison,future ideas and data. 
Specifically,Users can pinpoint any location in New York City by zipcode and choose problems and species of trees they interested via our map. Then total tree numbers, species proportion, health proportion, guard condition and sidewalk condition will be presented on the right output section.


### [App Link](https://feichigu.shinyapps.io/proj2-2019-group5-tree/)

+ **Contribution statement**: 
Data acquisition and manipulation: Everyone 
Data integration(Acquitted data into one csv): Feichi Gu
UI Design: Feichi Gu, Jess Mathew, Zian Zhou
Server-Introduction tab: Nyu Chai
Server-Map tab: Feichi Gu(spicies), Jess Mathew(heatmaps), Zian Zhou(problems)
Server-Comparison tab: Feichi Gu(spicies), Jess Mathew(heatmaps), Zian Zhou(maps)
Debug help:  Jess Mathew
Next Steps tab: Jess Mathew
Presentation: Zian Zhou
Github Readme: Nyu Chai
Github arrangement: Zian Zhou



Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── app/
├── lib/
├── data/
├── doc/
└── output/
```

Please see each subfolder for a README file.

