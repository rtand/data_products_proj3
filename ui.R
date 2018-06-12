#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Crude Oil and Natural Gas Drilling Activity"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("rig_type"
                         , label = "Rig Type:"
                         , choices = c("NatGas","Oil")
                         , selected = "NatGas")
      ,checkboxGroupInput("years"
                          , h3("Years")
                          , choices = 2010:2018
                          , selected = c(2018, 2017))
    ),
    
    mainPanel(
      htmlOutput("text1"), 
      plotOutput("rig_count"),
      htmlOutput("text2"), 
      plotOutput("avg"),
      textOutput("source"),
      textOutput("git")
    )
  )
))
