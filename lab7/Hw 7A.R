if (!require("tidyverse")) install.packages('tidyverse')
library("tidyverse")

if (!require("shiny")) install.packages('shiny')
library("shiny")

if (!require("shinydashboard")) install.packages('shinydashboard')
library("shinydashboard")

UC_admit <- readr::read_csv("data/UC_admit.csv")
options(scipen=999)

ui <- dashboardPage(
  dashboardHeader(title = "Ethnicity distributions over UC Campuses"),
  dashboardSidebar(disable = T),
  dashboardBody(
    selectInput("x", "Select Statistic", choices = c("Campus", "Academic_Yr", "Category"), 
                selected = "Campus"),
    plotOutput("plot", width = "1000px", height = "800px")
  ))
server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(UC_admit, aes_string(x="Ethnicity",y="FilteredCountFR",fill = input$x)) + 
      
      geom_bar(stat = "identity", position = "dodge") + 
      theme_light(base_size = 18)
  })
  session$onSessionEnded(stopApp)
}

shinyApp(ui, server)