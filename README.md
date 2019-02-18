# Olympic_Shiny

This Shiny App visualizes and analyzes data on the Olympic Games from 1896 to 2016.

https://matthewrautionmaa.shinyapps.io/Olympic_Shiny/

Data is from: https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results.

Data includes athlete name, gender, age, height, weight, team, NOC (country), games, year, season, city, sport, and medal. 

Data is missing in 1916, 1940 and 1944 because of World War I or World War II. Data is more sparse in 1980 because the Olympics were boycotted by the USA and other countries. Winter and Summer Olympics were held in the same year until 1994 (Lillehammer, Norway) when they began alternating every two years (as seen in gender graphs).

GoogleVis was used to visualize a world map with total medals by country and historical host cities. You are able to choose which country data you would like to look at in the country drop down. The graphs visualizes athlete height, weight and age against gender and sport. Additionally, you can look at the top athletes in the chosen country and the top countries by sport in the sport dropdown. All code was written in R.
