---
title: "Lab 7 Homework"
author: "Kyle Tran"
date: "2020-02-27"
output:
  html_document:
    theme: spacelab
    toc: no
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for any included code chunks to run.  

## Libraries

```r
library(tidyverse)
library(shiny)
library(shinydashboard)
```

## Data
The data for this assignment come from the [University of California Information Center](https://www.universityofcalifornia.edu/infocenter). Admissions data were collected for the years 2010-2019 for each UC campus. Admissions are broken down into three categories: applications, admits, and enrollees. The number of individuals in each category are presented by demographic.  

```r
UC_admit <- readr::read_csv("data/UC_admit.csv")
```

```
## Parsed with column specification:
## cols(
##   Campus = col_character(),
##   Academic_Yr = col_double(),
##   Category = col_character(),
##   Ethnicity = col_character(),
##   `Perc FR` = col_character(),
##   FilteredCountFR = col_double()
## )
```

**1. Use the function(s) of your choice to get an idea of the overall structure of the data frame, including its dimensions, column names, variable classes, etc. As part of this, determine if there are NA's and how they are treated.**  

```r
glimpse(UC_admit)
```

```
## Observations: 2,160
## Variables: 6
## $ Campus          <chr> "Davis", "Davis", "Davis", "Davis", "Davis", "Davis...
## $ Academic_Yr     <dbl> 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 201...
## $ Category        <chr> "Applicants", "Applicants", "Applicants", "Applican...
## $ Ethnicity       <chr> "International", "Unknown", "White", "Asian", "Chic...
## $ `Perc FR`       <chr> "21.16%", "2.51%", "18.39%", "30.76%", "22.44%", "0...
## $ FilteredCountFR <dbl> 16522, 1959, 14360, 24024, 17526, 277, 3425, 78093,...
```

```r
naniar::miss_var_summary(UC_admit)
```

```
## # A tibble: 6 x 3
##   variable        n_miss pct_miss
##   <chr>            <int>    <dbl>
## 1 Perc FR              1   0.0463
## 2 FilteredCountFR      1   0.0463
## 3 Campus               0   0     
## 4 Academic_Yr          0   0     
## 5 Category             0   0     
## 6 Ethnicity            0   0
```


**2. The president of UC has asked you to build a shiny app that shows admissions by ethnicity across all UC campuses. Your app should allow users to explore year, campus, and admit category as interactive variables. Use shiny dashboard and try to incorporate the aesthetics you have learned in ggplot to make the app neat and clean.**

```r
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
```

<!--html_preserve--><div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div><!--/html_preserve-->


**3. Make alternate version of your app above by tracking enrollment at a campus over all of the represented years while allowing users to interact with campus, category, and ethnicity.**

```r
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
```

<!--html_preserve--><div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div><!--/html_preserve-->


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences. 
