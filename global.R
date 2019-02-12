## golbal.R ##

library(dplyr)
library(googleVis)
library(rworldmap)
library(plotly)
library(ggplot2)
library(googleVis)
library(sp)
library(rgdal)
library(ggalt)
library(ggthemes)
library(tidyverse)
library(rsconnect)

##### DATA FRAMES #####

olympics = read.csv(file = "athlete_events.csv", stringsAsFactors = FALSE)
noc_regions = read.csv(file = "noc_regions.csv", stringsAsFactors = FALSE)

# merge olympic csv data frames #####

df = data.frame(olympics)
df_regions = data.frame(noc_regions)

head(df)
head(df_regions)

df_merge = merge(df, df_regions)

df_merge

# Create new dataframe with medals by country #####

medals_region = df_merge %>% na.omit() %>% group_by(., region) %>% count(., Medal)

colnames(medals_region)[1] = 'Country'

medals_region$Country = as.character(medals_region$Country)

head(medals_region)

medals_region$Country

# rename countries #####

medals_region[medals_region$Country == 'USA', ]$Country = 'United States'

medals_region$Country

# create medal string column #####

medals_region$medal_string = paste0(medals_region$Medal, " : ", medals_region$n)

medals_region1 = medals_region %>%
  group_by(., Country) %>%
  mutate(., medal_string1 = paste0(medal_string, collapse = " ")) %>%
  select(., medal_string1, Country) %>%
  unique()

medals_region1

# Sport v. Country with Medal Count DataFrame #####

Sport_Country_MedalCount = df_merge %>%
  na.omit %>%
  select(Sport, Medal, region) %>%
  group_by(Sport, region) %>%
  count(Medal)


# Country Selector #####
Country = unique(df_merge['region'])
# Sport Selector #####
Sport = unique(df_merge['Sport'])
Sport_ = Sport$Sport[order(Sport)]



##### GRAPHS #####

# Host City Map #####

world1 = map_data("world")
world1

regioncity = unique(df_merge %>% select(Year, City))

data("world.cities")

regioncitylatlong = world.cities %>% select(name, country.etc, lat, long)

colnames(regioncitylatlong)[1] = 'City'
colnames(regioncitylatlong)[2] = 'Country'

HostCityDF = merge(regioncity, regioncitylatlong)

HostCityDF = HostCityDF[-c(5, 7, 9, 18, 19, 20, 21, 24, 25, 27, 29, 31, 37, 39, 52, 54), ]

head(medals_region)

hostcitymap = ggplotly(
  ggplot() +
    geom_polygon(
      data = world,
      aes(x = long, y = lat, group = group),
      color = "#888888",
      fill = "#f2caae"
    ) +
    geom_point(data = HostCityDF, aes(x = long, y = lat), color = 'red') +
    theme(
      panel.background = element_rect(
        fill = "lightblue",
        colour = "lightblue",
        size = 0.5,
        linetype = "solid"
      ),
      panel.grid.major = element_line(
        size = 0.5,
        linetype = 'solid',
        colour = "lightblue"
      ),
      panel.grid.minor = element_line(
        size = 0.25,
        linetype = 'solid',
        colour = "lihtblue"
      )
    )
)

# World Map Medals by Country #####

Geo = gvisGeoChart(
  medals_region1,
  locationvar = "Country",
  colorvar = "",
  hovervar = "medal_string1"
)

# Gender v. Height Plot #####

avgheight = df_merge %>% select(., Year, Height, Sex, region) %>% group_by(Year, Sex) %>% mutate(avgh = mean(Height, na.rm = TRUE))


HeightSexPlot = ggplot(df_merge, aes(x = Year, y = Height)) +
  geom_point(shape = 1, alpha = .3) +
  geom_line(data = avgheight %>% filter(region ==
                                          "USA"),
            aes(
              x = Year,
              y = avgh,
              color = Sex,
              size = .5
            ))

HeightSexPlot


# Gender v. Weight Plot #####

avgweight = df_merge %>% select(., Year, Weight, Sex, region) %>% group_by(Year, Sex) %>% mutate(avgw = mean(Weight, na.rm = TRUE))


WeightSexPlot = ggplot(data = df_merge, aes(x = Year, y = Weight)) +
  geom_point(shape = 1, alpha = .3) +
  geom_line(data = avgweight, aes(
    x = Year,
    y = avgw,
    color = Sex,
    size = .5
  ))

WeightSexPlot

# Gender v. Age Plot #####

avgage = df_merge %>% select(., Year, Age, Sex, region) %>% group_by(Year, Sex) %>% mutate(avga = mean(Age, na.rm = TRUE))

AgeSexPlot = ggplot(data = df_merge, aes(x = Year, y = Age)) +
  geom_point(shape = 1, alpha = .3) +
  geom_line(data = avgage, aes(
    x = Year,
    y = avga,
    color = Sex,
    size = .5
  ))

AgeSexPlot

# Sport v. Age Plot #####

avg_age_sport = df_merge %>% select(Sport, Age, region) %>% group_by(Sport) %>% mutate(mean(Age, na.rm = T))

sportage = ggplot(df_merge, aes(x = Sport, y = Age)) +
  geom_boxplot(alpha = 0.3) + coord_flip() + theme_minimal()

sportage

ggplot(iris, aes(x = reorder(Species, Sepal.Width, FUN = median), y = Sepal.Width)) + geom_boxplot()

# Sport v. Height ####

sportheight = ggplot(data = df_merge, aes(x = Sport, y = Height)) +
  geom_boxplot() + coord_flip()

# Sport v. Weight ####

sportweight = ggplot(data = df_merge, aes(x = Sport, y = Weight)) +
  geom_boxplot() + coord_flip()

# Medal v. Age + Omit NA DataFrame ####

df_naomit = df_merge %>% drop_na()

medalage = ggplot(df_naomit, aes(x = Medal, y = Age)) + geom_boxplot()

# Medal v. Height ####

medalheight = ggplot(df_naomit, aes(x = Medal, y = Height)) + geom_boxplot()

# Medal v. Weight ####

medalweight = ggplot(df_naomit, aes(x = Medal, y = Weight)) + geom_boxplot()

# Top 10 Countries by Sport #####

Sport_Country_MedalCount

#reorder medals

Sport_Country_MedalCount$Medal = factor(Sport_Country_MedalCount$Medal,
                                        levels = c("Gold", "Silver", "Bronze"))

topcountry = ggplot(Sport_Country_MedalCount %>% filter(Sport == "Basketball")) +
  geom_bar(aes(x = region, y = n, fill = Medal), stat = "identity") +
  scale_fill_manual(values = c("gold", "gray69", "peru")) +
  coord_flip()
topcountry

# Countries ordered by medal and total medal count
Sport_Country_MedalCount %>% filter(Sport == "Basketball") %>% arrange(desc(n))
#Countries ordered by total Medal Count
Sport_Country_MedalCount %>%
  filter(Sport == "Basketball") %>%
  summarise(total_medals = sum(n)) %>%
  arrange(desc(total_medals))

# Top Atheletes by Country #####

AtheletesCountry = df_merge %>% group_by(Name, Medal, region) %>% na.omit() %>% select(Name, Medal, region) %>%
  count(Medal)
AtheletesCountry

AtheletesCountry$Medal = factor(AtheletesCountry$Medal,
                                levels = c("Gold", "Silver", "Bronze"))

topathletes = ggplot(AtheletesCountry %>% filter(region == 'USA', n > 5)) +
  geom_bar(aes(x = Name, y = n, fill = Medal), stat = "identity") +
  scale_fill_manual(values = c("gold", "gray69", "peru")) +
  coord_flip()


