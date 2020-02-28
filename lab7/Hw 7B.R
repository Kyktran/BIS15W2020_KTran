if (!require("tidyverse")) install.packages('tidyverse')
library("tidyverse")

if (!require("shiny")) install.packages('shiny')
library("shiny")

if (!require("shinydashboard")) install.packages('shinydashboard')
library("shinydashboard")
UC_admit <- readr::read_csv("data/UC_admit.csv")
options(scipen=999)
ui <- dashboardPage(
  dashboardHeader(title = "Distributions UC Davis"),
  dashboardSidebar(disable = T),
  dashboardBody(
    selectInput("x", "Select Statistic", choices = c("Campus", "Ethnicity", "Category"), 
                selected = "Campus"),
    plotOutput("plot", width = "1000px", height = "800px")
  ))
server <- function(input, output, session) {
  output$plot <- renderPlot({
    UC_admit %>% 
      group_by(Ethnicity, Academic_Yr, Campus, Category) %>% 
      filter(Campus == "Davis", Ethnicity != "All") %>% 
      summarise(Amount = sum(FilteredCountFR)) %>% 
      ggplot(aes_string(x="Academic_Yr",y="Amount",fill = input$x)) + 
      
      geom_bar(stat = "identity", position = "dodge") + 
      theme_light(base_size = 18)
  })
  session$onSessionEnded(stopApp)
}

shinyApp(ui, server)