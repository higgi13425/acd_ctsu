# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
# note google sheet = acd_ctsu_timelines
# gmail/google drive account: acdctsu@gmail.com, michigan


## app.R ##

server <- function(input, output) {
 
  output$docFApp <- renderInfoBox({
    infoBox(
      "Complete Docs to Feasibility Appr.", paste0(time$docFApp, " days"), icon = icon("inbox", lib="glyphicon"),
      color="aqua"
    )
  })
  
  output$FeasToPlanMtg <- renderInfoBox({
    infoBox(
      "Feasibility Appr. to Planning Mtg", paste0(time$FeasToPlanMtg, " days"), icon = icon("users"),
      color="maroon"
    )
  })
  
  output$PlanMtgToPIAppBudg <- renderInfoBox({
    infoBox(
      "Planning Mtg to PI Appr. Budget", paste0(time$PlanMtgToPIAppBudg, " days"), icon = icon("thumbs-o-up"),
      color="light-blue"
    )
  })
  
  output$PIAppBudgToFinalBudg <- renderInfoBox({
    infoBox(
      "PI Appr. Budget to Final Budget/PAF", paste0(time$PIAppBudgToFinalBudg, " days"), icon = icon("handshake-o"),
      color="green"
    )
  })
  
  #icon = icon("calendar-check-o" 


  output$PAFtoPAN <- renderInfoBox({
    infoBox(
      "PAF Routed to PAN/Enrollment", paste0(time$PAFToPAN, " days"), icon = icon("share-square"),
      color="purple"
    )
  })
  
  output$Total <- renderInfoBox({
    infoBox(
      "Total Time: Complete Docs to Enroll", paste0(time$TotalTime, " days"), icon = icon("calendar"),
      color="teal"
    )
  })
  
}

shinyApp(ui, server)