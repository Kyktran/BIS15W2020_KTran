---
title: "Lab 6 Homework"
author: "Kyle Tran"
date: "2/21/20"
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
```

## Resources
The idea for this assignment came from [Rebecca Barter's](http://www.rebeccabarter.com/blog/2017-11-17-ggplot2_tutorial/) ggplot tutorial so if you get stuck this is a good place to have a look.  

## Gapminder
For this assignment, we are going to use the dataset [gapminder](https://cran.r-project.org/web/packages/gapminder/index.html). Gapminder includes information about economics, population, and life expectancy from countries all over the world. You will need to install it before use. This is the same data that we used for the practice midterm. You may want to load that assignment for reference.  

```r
#install.packages("gapminder")
#install.packages("naniar")
#install.packages("skimr")
library("gapminder")
```

## Questions
The questions below are open-ended and have many possible solutions. Your approach should, where appropriate, include numerical summaries and visuals. Be creative; assume you are building an analysis that you would ultimately present to an audience of stakeholders. Feel free to try out different `geoms` if they more clearly present your results.  

**1. Use the function(s) of your choice to get an idea of the overall structure of the data frame, including its dimensions, column names, variable classes, etc. As part of this, determine how NAs are treated in the data.**  

```r
glimpse(gapminder)
```

```
## Observations: 1,704
## Variables: 6
## $ country   <fct> Afghanistan, Afghanistan, Afghanistan, Afghanistan, Afghani<U+2026>
## $ continent <fct> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia,<U+2026>
## $ year      <int> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997,<U+2026>
## $ lifeExp   <dbl> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.854, 40.<U+2026>
## $ pop       <int> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 1<U+2026>
## $ gdpPercap <dbl> 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 786.1134,<U+2026>
```

```r
gapminder
```

```
## # A tibble: 1,704 x 6
##    country     continent  year lifeExp      pop gdpPercap
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.
##  2 Afghanistan Asia       1957    30.3  9240934      821.
##  3 Afghanistan Asia       1962    32.0 10267083      853.
##  4 Afghanistan Asia       1967    34.0 11537966      836.
##  5 Afghanistan Asia       1972    36.1 13079460      740.
##  6 Afghanistan Asia       1977    38.4 14880372      786.
##  7 Afghanistan Asia       1982    39.9 12881816      978.
##  8 Afghanistan Asia       1987    40.8 13867957      852.
##  9 Afghanistan Asia       1992    41.7 16317921      649.
## 10 Afghanistan Asia       1997    41.8 22227415      635.
## # <U+2026> with 1,694 more rows
```

```r
?gapminder
naniar::miss_var_summary(gapminder)
```

```
## # A tibble: 6 x 3
##   variable  n_miss pct_miss
##   <chr>      <int>    <dbl>
## 1 country        0        0
## 2 continent      0        0
## 3 year           0        0
## 4 lifeExp        0        0
## 5 pop            0        0
## 6 gdpPercap      0        0
```


**2. Among the interesting variables in gapminder is life expectancy. How has global life expectancy changed between 1952 and 2007?**

```r
gapminder %>%
  group_by(year) %>%
  summarize(GlobalLifeExp= sum(lifeExp)) %>%
  ggplot(aes(x = year, y = GlobalLifeExp))+
  geom_jitter()
```

![](lab6_hw_files/figure-html/unnamed-chunk-4-1.png)<!-- -->


**3. How do the distributions of life expectancy compare for the years 1952 and 2007? _Challenge: Can you put both distributions on a single plot?_**

```r
gapminder %>%
  filter(year==1952|year==2007) %>%
  group_by(year)%>%
  ggplot(aes(x=country, y=lifeExp, fill=year)) +
  geom_bar(stat="identity")+
  coord_flip()
```

![](lab6_hw_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
##I don't know how to make the graph bigger in proportion to the text. Also, the next question makes me think I misinterpreted what the distribution is
```


**4. Your answer above doesn't tell the whole story since life expectancy varies by region. Make a summary that shows the min, mean, and max life expectancy by continent for all years represented in the data.**

```r
gapminder %>%
  group_by(continent) %>%
  summarise(MinLifeExp = min(lifeExp),
            MeanLifeExp = mean(lifeExp),
            MaxLifeExp = max(lifeExp))
```

```
## # A tibble: 5 x 4
##   continent MinLifeExp MeanLifeExp MaxLifeExp
##   <fct>          <dbl>       <dbl>      <dbl>
## 1 Africa          23.6        48.9       76.4
## 2 Americas        37.6        64.7       80.7
## 3 Asia            28.8        60.1       82.6
## 4 Europe          43.6        71.9       81.8
## 5 Oceania         69.1        74.3       81.2
```


**5. How has life expectancy changed between 1952-2007 for each continent? Try using `geom_line()` for this, including all continents on the same  plot.**

```r
gapminder %>%
  ggplot(aes(x=year, y=lifeExp, group=continent, color=continent)) +
  geom_line()
```

![](lab6_hw_files/figure-html/unnamed-chunk-7-1.png)<!-- -->


**6. We are interested in the relationship between per capita GDP and life expectancy; i.e. does having more money help you live longer?**

```r
gapminder %>%
 ggplot(aes(x=lifeExp, y=gdpPercap)) + 
  geom_jitter()+geom_smooth()
```

```
## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
```

![](lab6_hw_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


**7. There is extreme disparity in per capita GDP. Rescale the x axis to make this easier to interpret. How would you characterize the relationship?**

```r
gapminder %>% 
  ggplot(aes(x=lifeExp, y=gdpPercap)) + 
  geom_jitter()+geom_smooth()+
  scale_y_log10()
```

```
## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
```

![](lab6_hw_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

```r
##while not exponentially, the graph shows that there is a correlation between GDP and average life expectancy
```


**8. Which countries have had the largest population growth since 1952?**

```r
gapminder %>%
  group_by(country) %>% 
  summarize(pop1=first(pop),
            pop2=last(pop)) %>% 
  mutate(diff=pop2-pop1) %>% 
  arrange(desc(diff))
```

```
## # A tibble: 142 x 4
##    country            pop1       pop2      diff
##    <fct>             <int>      <int>     <int>
##  1 China         556263527 1318683096 762419569
##  2 India         372000000 1110396331 738396331
##  3 United States 157553000  301139947 143586947
##  4 Indonesia      82052000  223547000 141495000
##  5 Brazil         56602560  190010647 133408087
##  6 Pakistan       41346560  169270617 127924057
##  7 Bangladesh     46886859  150448339 103561480
##  8 Nigeria        33119096  135031164 101912068
##  9 Mexico         30144317  108700891  78556574
## 10 Philippines    22438691   91077287  68638596
## # <U+2026> with 132 more rows
```


**9. Use your results from the question above to plot population growth for the top five countries since 1952.**

```r
gapminder2 <- gapminder%>%
  filter(country == "China" | country == "India" | country == "United States" | country == "Indonesia" | country == "Brazil" )
gapminder2 %>%
   ggplot(aes(x=year, y=pop)) +
  geom_jitter()+
   facet_wrap(~country)
```

![](lab6_hw_files/figure-html/unnamed-chunk-11-1.png)<!-- -->


**10. How does per capita GDP growth compare between these same five countries?**

```r
gapminder2 %>%
   ggplot(aes(x=year, y=gdpPercap)) +
  geom_jitter()+
   facet_wrap(~country)
```

![](lab6_hw_files/figure-html/unnamed-chunk-12-1.png)<!-- -->


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences. 
