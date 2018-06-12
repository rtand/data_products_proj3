library(shiny)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(ggplot2)
library(ggthemes)
months <- data.frame(abb=month.abb, num = as.factor(1:12), stringsAsFactors=FALSE)

url <- "https://raw.githubusercontent.com/rtand/data_products_proj3/master/rig_count.csv"
rigs <- read_csv(url) %>%
  rename(Oil = oil_rigs, NatGas=ng_rigs) %>%
  mutate(Year = str_sub(Month, 5, 9)) %>%
  filter(Year>=2010) %>%           
  mutate(Year = factor(Year)
         ,Date = Month
         ,Month = str_sub(Month, 1, 3)
  ) %>%
  gather(Type, Rig_Count, c("NatGas","Oil")) %>%
  inner_join(months, by=c("Month"="abb")) %>% 
  rename(month_abb=Month, Month=num) 
months<- rigs %>% select(Month) %>% distinct() %>% arrange(Month)
years <- rigs %>% select(Year) %>% distinct() %>% arrange(Year)
types <- rigs %>% select(Type) %>% distinct() %>% arrange(Type)

shinyServer(function(input, output) {
   
  output$rig_count <- renderPlot({
    ggplot(filter(rigs, Type==input$rig_type & Year %in% input$years ), aes(x=Month, y=Rig_Count, colour=Year, group=Year)) + 
      geom_line() +
      geom_point() +
      facet_grid(Type ~ .) + 
      labs(
        title = "Rig Count by Month, Colored by Year",
        x = "Month",
        y = "Rig Count",
        color = "Year"
      ) +
      theme_hc(bgcolor = "darkunica") +
      scale_colour_hc('darkunica')
    })
  
  output$avg <- renderPlot({
    ggplot(rigs %>% filter(Type==input$rig_type & Year %in% input$years) %>% group_by(Month, Type) %>% summarise(Avg_Rig_Count=mean(Rig_Count)) %>% ungroup() %>% mutate(Month=as.numeric(Month))
      , aes(x=Month, y=Avg_Rig_Count, colour=Type)) + 
      geom_line() +
      geom_point() +
      labs(
        title = "Mean Rig Count by Month",
        x = "Month",
        y = "Avg. Rig Count",
        color = "Type"
      ) +
      theme_hc(bgcolor = "darkunica") +
      scale_colour_solarized("blue")
  })
  output$text1 <- renderUI({"The U.S. Energy Information Administration (EIA) publishes a monthly count of active Oil and Natuiral Gas drilling rigs. 
    Using the below controls, you can select the type of rig (Crude Oil, or NAtural Gas) and also compare years"})
  output$text2 <- renderUI({"Using the controls to the side, the below chart will show the average number of rigs over all selected years by month and Type"})
  
  output$source <- renderText({"Data: https://www.eia.gov/dnav/ng/ng_enr_drill_s1_m.htm"})
  output$git <- renderText({"https://github.com/rtand/data_products_proj3"})
  
})
