## ui.R ##

library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = "Olympic Games Data"),
  dashboardSidebar(
    sidebarUserPanel("Matthew Rautionmaa",
                     image = "https://prsay.prsa.org/wp-content/uploads/2016/05/blue-81847_1280-810x573.jpg"),
    sidebarMenu(
      menuItem("World Map", tabName = "worldmap", icon = icon("globe")),
      menuItem(
        "Host City Map",
        tabName = "hostcity",
        icon = icon("map-marker")
      ),
      menuItem(
        "Gender Graphs",
        tabName = "gender",
        icon = icon("user"),
        menuSubItem("Gender v. Height", tabName = "genderheight"),
        menuSubItem("Gender v. Weight", tabName = "genderweight"),
        menuSubItem("Gender v. Age", tabName = "genderage")
      ),
      menuItem(
        "Sports Graphs",
        tabName = "sports",
        icon = icon("basketball-ball"),
        menuSubItem("Sport v. Age", tabName = "sportage"),
        menuSubItem("Sport v. Height", tabName = "sportheight"),
        menuSubItem("Sport v. Weight", tabName = "sportweight")
      ),
      menuItem(
        "Medal Graphs",
        tabName = "medals",
        icon = icon("medal"),
        menuSubItem("Medal v. Age", tabName = "medalage"),
        menuSubItem("Medal v. Height", tabName = "medalheight"),
        menuSubItem("Medal v. Weight", tabName = "medalweight")
      ),
      menuItem("Top Countries", tabName = "topcountry", icon = icon("list")),
      menuItem("Top 10 Athletes", tabName = "topathlete", icon = icon("star")),
      menuItem("About", tabName = "about", icon = icon("book"))
    ),
    selectizeInput("selected",
                   "Select Country",
                   Country, selected = "USA")
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "worldmap",
              fluidRow(box(
                htmlOutput("worldmap"), width = 12
              ))),
      tabItem(tabName = "hostcity",
              fluidRow(box(
                width = 12, (plotlyOutput(
                  "hostcitymap", height = 700, width = 1150
                ))
              ))),
      tabItem(tabName = "genderheight",
              fluidRow(box(
                width = 12, (plotlyOutput(
                  "genderheight", height = 700, width = 1150
                ))
              ))),
      tabItem(tabName = "genderweight",
              fluidRow(box(
                width = 12, (plotlyOutput(
                  "genderweight", height = 700, width = 1150
                ))
              ))),
      tabItem(tabName = "genderage",
              fluidRow(box(
                width = 12, (plotlyOutput(
                  "genderage", height = 700, width = 1150
                ))
              ))),
      tabItem(tabName = "sportage",
              fluidRow(box(
                width = 12, (plotlyOutput(
                  "sportage", height = 700, width = 1150
                ))
              ))),
      tabItem(tabName = "sportheight",
              fluidRow(box(
                width = 12, (plotlyOutput(
                  "sportheight", height = 700, width = 1150
                ))
              ))),
      tabItem(tabName = "sportweight",
              fluidRow(box(
                width = 12, (plotlyOutput(
                  "sportweight", height = 700, width = 1150
                ))
              ))),
      tabItem(tabName = "medalage",
              fluidRow(box(
                width = 12, (plotOutput(
                  "medalage", height = 500, width = 1150
                ))
              ))),
      tabItem(tabName = "medalheight",
              fluidRow(box(
                width = 12, (plotOutput(
                  "medalheight", height = 500, width = 1150
                ))
              ))),
      tabItem(tabName = "medalweight",
              fluidRow(box(
                width = 11, (plotOutput(
                  "medalweight", height = 500, width = 1150
                ))
              ))),
      tabItem(tabName = "topcountry",
              fluidRow(box(
                width = 9, (plotlyOutput(
                  "topcountry", height = 700, width = 800
                ))
              ),
              (
                box(
                  title = "Select Sport",
                  width = 3,
                  selectizeInput("selectedsport", "Select Sport", Sport_, selected = "Basketball")
                )
              ))),
      tabItem(tabName = "topathlete",
              fluidRow(box(width = 12, (
                plotlyOutput("topathlete", height = 700, width = 1150)
              )))),
      tabItem(
        tabName = "about", includeMarkdown("Olympic_About.rmd")
      )
    )
  )
))
