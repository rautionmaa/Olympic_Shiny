## server.R ##

function(input, output){

# World Map #####
medals_region1$medal_string1 = paste(medals_region1$Country[1:132], medals_region1$medal_string1[1:132], sep = " - ")  

  output$worldmap = renderGvis({
    gvisGeoChart(
      medals_region1,
      "Country",
      hovervar = "medal_string1",
      options = list(region="world", displayMode="regions",
        width = "1100",
        height = "700"
      )
    ) 
  })
# Host City Map #####
  output$hostcitymap = renderPlotly(
    ggplot(data = HostCityDF, aes(x = long, y = lat)) +
      geom_polygon(
        data = world,
        aes(x = long, y = lat, group = group),
        color = "#888888",
        fill = "#f2caae"
      ) +
      geom_point(aes(text=paste(City,":", Year)), color = 'red') +
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

# Gender Graphs ####
  
avgh1 = avgheight %>% 
    group_by(Sex,Year) %>% 
    summarise(mean(avgh))
  
  output$genderheight = renderPlotly(
    ggplot(
      df_merge %>% filter(region == input$selected) ,
      aes(x = Year, y = Height)
    ) +
      geom_point(shape = 1, alpha = .3) + theme_minimal() +
      geom_line(
        data = avgheight %>% filter(region == input$selected),
        size = 1.25,
        aes(x = Year, y = avgh, color = Sex) 
      )+ labs(color='Gender') + geom_line(data = avgh1, aes(x=Year, y = `mean(avgh)`, color = Sex), linetype=2) 
  )
  
  
  output$genderweight = renderPlotly(
    ggplot(
      df_merge %>% filter(region == input$selected),
      aes(x = Year, y = Weight)
    ) +
      geom_point(shape = 1, alpha = .3) + theme_minimal() +
      geom_line(
        data = avgweight %>% filter(region == input$selected),
        size = 1.25,
        aes(x = Year, y = avgw, color = Sex)
      )+ labs(color='Gender') + geom_line(data = avgweight, aes(x=Year, y = avgw, color = Sex), linetype=2)
  )
  
  
  output$genderage = renderPlotly(
    ggplot(
      df_merge %>% filter(region == input$selected),
      aes(x = Year, y = Age)
    ) +
      geom_point(shape = 1, alpha = .3) + theme_minimal() +
      geom_line(
        data = avgage %>% filter(region == input$selected),
        size = 1.25,
        aes(x = Year, y = avga, color = Sex)
      )+ labs(color='Gender') + geom_line(data = avgage, aes(x=Year, y = avga, color = Sex), linetype=2)
  )
    
# Sport Graphs ####
  
  output$sportage = renderPlotly(ggplot(
    df_merge %>% filter(region == input$selected),
    aes(x = Sport, y = Age, fill = Sport)
  ) +
    geom_boxplot() +  theme_minimal() + coord_flip())
  
  
  output$sportheight = renderPlotly(ggplot(
    df_merge %>% filter(region == input$selected),
    aes(x = Sport, y = Height, fill = Sport)
  ) +
    geom_boxplot() +  theme_minimal() + coord_flip())
  
  
  output$sportweight = renderPlotly(ggplot(
    df_merge %>% filter(region == input$selected),
    aes(x = Sport, y = Weight, fill = Sport)
  ) +
    geom_boxplot() +  theme_minimal() + coord_flip())

# Medals Graphs ####
  output$medalage = renderPlot(ggplot(
    df_naomit %>% filter(region == input$selected),
    aes(x = Medal, y = Age)
  ) + geom_boxplot())
  output$medalheight = renderPlot(ggplot(
    df_naomit %>% filter(region == input$selected),
    aes(x = Medal, y = Height)
  ) + geom_boxplot())
  output$medalweight = renderPlot(ggplot(
    df_naomit %>% filter(region == input$selected),
    aes(x = Medal, y = Weight)
  ) + geom_boxplot())
  
# Top Country Graph ####
  output$topcountry = renderPlotly(

    ggplot(
      Sport_Country_MedalCount %>% filter(Sport == input$selectedsport)
    ) + theme_minimal() +
      geom_bar(aes(
        x = reorder(region,n), y = n, fill = Medal
      ), stat = "identity") +
      scale_fill_manual(values = c("gold", "gray69", "peru")) +
      coord_flip() + xlab("Country") + ylab("Number of Medals")
  )

# Top Athletes ####
  reactive_1 = reactive({
    AtheletesCountry %>%
      filter(region==input$selected) %>% 
      spread(.,Medal, n) %>%
      mutate(total = sum(Gold,Silver,Bronze, na.rm=T)) %>%
      arrange(desc(total))
  })
  
  output$topathlete = renderPlotly({
    
    tmp = reactive_1()
    ggplot(
      tmp[1:10,] %>% gather(key="Medal", value="n", c(Gold,Silver,Bronze)) %>% select(-total)  %>%
        arrange(Name) 
    ) + theme_minimal() +
      geom_bar(aes(
        x = reorder(Name, -n), y = n, fill = factor(Medal, levels =c("Gold", "Silver", "Bronze"))
      ), stat = "identity") +
      scale_fill_manual(values = c("gold", "gray69", "peru")) +
      coord_flip() + xlab("Athlete") + ylab("Total Medals") +
      guides(fill=guide_legend(title="Medal"))
  })
}
