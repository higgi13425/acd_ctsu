## ui.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "ACD CTSU Clinical Trial Timelines", titleWidth=450),
  
  dashboardSidebar( 
    sidebarMenu(
      menuItem("Average Days", tabName = "average_days", icon = icon("calendar")),
      menuItem("Distributions", tabName = "distributions", icon = icon("calendar-check-o"))
    )
  ),
  
  dashboardBody(
    tabItems(
      #first tab content
      tabItem(tabName = "average_days",
              fluidRow(
                infoBoxOutput("docFApp"),
                infoBoxOutput("FeasToPlanMtg"),
                infoBoxOutput("PlanMtgToPIAppBudg"),
                infoBoxOutput("PIAppBudgToFinalBudg"),
                infoBoxOutput("PAFtoPAN"),
                infoBoxOutput("Total")
              )
      ),
      #second tab content
      tabItem(
        tabName = "distributions",
        fluidRow(
          h2("Distributions"),
          box(title="Boxplot",  boxplot(Sepal.Length~Species, data=iris))
        )
      )
    )
  )
)       

