# Stuff to do

# take full excel file, move to google sheets

# set up an IFTTT so you can email excel to acd_ctsu@gmail.com and it overwrites the acd_ctsu google sheet

# read in full excel file data, without sums, from google sheet into R

# use full excel file observations to make an interactive ggiraph with tooltips for StudyName and PI, colored by Dept/Division
# will need to gather days for each step into a new, tall tibble w columns step and days, keep studyname, PI, Dept
# see webpage 'ggiraph in shiny'

library(ggplot2)
#library(ggiraph)
#library(ggiraphExtra)
library(plotly)
library(magrittr)
library(dplyr)
library(readxl)
library(tidyr)
library(purrr)
library(stringr)

test<- read_excel("~/Documents/Rcode/acd_ctsu/Pre-Award Task List Pivot Table 8.31.2017.xlsx", sheet = "Sheet1")

test<-test %>% select(c(2:4,11,17, 23,26,29,34,26)) 

names(test)<- c("dept", "title", "PI", "docs_to_feas_approval", "feas_approve_to_planning_meeting", 
                 "mtg_to_PIapprov_budget", "PIapprov_budget_to_finalbudget", "feas_approval_to_IRB_submit", "PAFtoPAN")
ctsu_data <- test %>% gather(step, days, 4:9) %>% filter(!is.na(days)) %>% filter(!is.na(dept))

ctsu_data$fstep <- as.factor(ctsu_data$step)
levels(ctsu_data$fstep)=c("docs_to_feas_approval", "feas_approve_to_planning_meeting", 
                          "mtg_to_PIapprov_budget", "PIapprov_budget_to_finalbudget", "feas_approval_to_IRB_submit", "PAFtoPAN")
ctsu_data$nstep <- as.numeric(ctsu_data$fstep)

ctsu2<- ctsu_data %>% mutate(nstep = nstep + runif(nrow(ctsu_data), min=-0.4, max = 0.4)) #add some jitter manually to get some spread
#cleanup ctsu2$title
ctsu2 <- ctsu2 %>% filter(!is.na(title))
ctsu2$title<- tolower(ctsu2$title)

ctsu2$title <- gsub("\\.", "", ctsu2$title)
ctsu2$title <- gsub("\\'", "", ctsu2$title)
ctsu2$title <- gsub("\\-", "", ctsu2$title)
ctsu2$title <- gsub("\\(", "", ctsu2$title)
ctsu2$title <- gsub("\\)", "", ctsu2$title)
ctsu2$title <- gsub("sponsor", "", ctsu2$title)
ctsu2$title <- gsub("doubleblind", "", ctsu2$title)
ctsu2$title <- gsub("randomized", "", ctsu2$title)
ctsu2$title <- gsub("randomised", "", ctsu2$title)
ctsu2$title <- gsub("multicenter", "", ctsu2$title)
ctsu2$title <- gsub("treatment", "", ctsu2$title)
ctsu2$title <- gsub("withdrawal", "", ctsu2$title)
ctsu2$title <- gsub("openlabel", "", ctsu2$title)
ctsu2$title <- gsub("study", "", ctsu2$title)
ctsu2$title <- gsub("placebocontrolled", "", ctsu2$title)
ctsu2$title <- gsub("safety", "", ctsu2$title)
ctsu2$title <- gsub("efficacy", "", ctsu2$title)
ctsu2$title <- gsub("multipledose", "", ctsu2$title)
ctsu2$title <- gsub("evaluation", "", ctsu2$title)
ctsu2$title <- gsub("of", "", ctsu2$title)
ctsu2$title <- gsub("\\\r", "", ctsu2$title)
ctsu2$title <- gsub("\\\n", "", ctsu2$title)
ctsu2$title <- gsub("\\\\,", "", ctsu2$title)
ctsu2$title <- gsub("parallel", "", ctsu2$title)
ctsu2$title <- gsub("group", "", ctsu2$title)
ctsu2$title <- gsub("  ", " ", ctsu2$title)
ctsu2$title <- gsub(" and ", " ", ctsu2$title)
ctsu2$title <- gsub(" the ", " ", ctsu2$title)
ctsu2$title <- gsub(" a ", " ", ctsu2$title)
ctsu2$title <- gsub(" an ", " ", ctsu2$title)
ctsu2$title <- gsub("a ", " ", ctsu2$title)
ctsu2$title <- gsub("an ", " ", ctsu2$title)
ctsu2$title <- gsub("open", "", ctsu2$title)
ctsu2$title <- gsub("label", "", ctsu2$title)
ctsu2$title <- gsub("doublemasked", "", ctsu2$title)
ctsu2$title <- gsub("clinical", "", ctsu2$title)
ctsu2$title <- gsub("trial", "", ctsu2$title)
ctsu2$title <- gsub(",", "", ctsu2$title, fixed=TRUE)
ctsu2$title <- gsub("\u0096", "", ctsu2$title, fixed=TRUE)
ctsu2$title <- gsub("  ", " ", ctsu2$title)
ctsu2$title <-str_trim(ctsu2$title)
ctsu2$tip<- paste0(ctsu2$PI, "\n", ctsu2$title)

g <- ggplot(ctsu2, aes(x=nstep, y=days, color = dept))  + 
  theme(legend.position = "top", legend.text = element_text(size=9))+
  annotate(geom="text",x=1, y=-25, label="Doc2Feas", color="blue") +
  annotate(geom="text",x=2, y=-25, label="Feas2Plan", color="blue") +
  annotate(geom="text",x=3, y=-25, label="Plan2PIbudg", color="blue") +
  annotate(geom="text",x=4, y=-25, label="PIbudg2final", color="blue") +
  annotate(geom="text",x=5, y=-25, label="Feas2IRBsub", color="blue") +
  annotate(geom="text",x=6, y=-25, label="PAF2PAN", color="blue") +
  xlab("Steps to Enrollment") +
  ylab("Days in Each Step") 
g
my_gg <- g + geom_point_interactive(aes(tooltip = tip) )
ggiraph(code=print(my_gg))

#ggiraph attempt
mpg %>% mutate(cyl2 = cyl + runif(nrow(mpg), min=-0.45, max = 0.45)) -> mpg2 #add some jitter manually to get some spread
g <- ggplot(mpg2, aes(x=cyl2, y=cty, color = manufacturer)) # x= step,y=days, color= dept
my_gg <- g + geom_point_interactive(aes(tooltip = paste0(manufacturer, " ",model))) # Study name or PI name for tooltip in place of model
ggiraph(code = print(my_gg))

# now try ggplotly
p <- ggplot(data=mpg, aes(x=fclass, y=cty)) +
  geom_point(aes(text = paste0("Model: ", model)))
ggplotly(p)
  
#now try plotly
plot_ly(mpg, x= ~fclass, y= ~cty, color= ~manufacturer, text = ~paste("Highway: ", hwy), type='scatter')
#needs jitter, not available
#try with manual jitter
mpg %>% mutate(cyl2 = cyl + runif(nrow(mpg), min=-0.4, max = 0.4)) -> mpg2
plot_ly(mpg2, x= ~cyl2, y= ~cty, color= ~manufacturer, text = ~paste(manufacturer, model, "Highway: ",hwy), type='scatter')
#kinda works
#try with categorical x and labels
mpg2$numclass<-as.numeric(as.factor(mpg$class)) + runif(nrow(mpg), min=-0.4, max = 0.4)
labels <- c("one", "two", "Three", "SUV", "cyclocross", "Six", "seven")
a<- list(
  title="Class",
  ticktext = labels,
  tickvals = mpg$class
)
plot_ly(mpg2, x= ~numclass, y= ~cty, color= ~manufacturer, marker =list(size=12),
        text = ~paste(manufacturer, model,'\n', "Highway: ",hwy), type='scatter') %>% 
        layout(xaxis=a)

#test labels
labels<- c('PANtoPAF', 'Docs to Mtg', 'PI Approve', "Budget", 'Meeting to approve', 'IRB', "PAN to enroll")
x<- c(1:7)
y <- rep(2,7)
data<- data.frame(labels, x, y)
p<- plot_ly(data, x=x, y=y, type = 'scatter', mode='text', text= ~labels) %>% 
  layout(title = "Labels",
         xaxis = list(title="class",
                      zeroline=TRUE,
                      range=c(0.5,7.5)),
         yaxis= list(title='range',
                     range=c(0,160))
         
        )
p


# add a calculated google sheet for monthly means - write a new row for each monthly update

# Display the monthly means, medians, lower IQR, upper IQR, min, max on the History Tab as a DT::dataTableOutput("file")
# see webpage on 'googlesheets in Shiny' (jennybc on github)

