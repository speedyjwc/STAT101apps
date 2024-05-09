library(shiny)
library(shinyjs)
library(shinycssloaders)
library(shinythemes)
library(bslib)
library(bsicons)

card1 <- card(
  card_header("Scrolling content"),
  # "This is it1."
  lapply(
    lorem::ipsum(paragraphs = 3, sentences = c(5, 5, 5)),
    tags$p
  )
)
card2 <- card(
  card_header("Nothing much here"),
  "This is it2."
)
card3 <- card(
  full_screen = TRUE,
  card_header("Filling content"),
  # "This is it3."
  card_body(
    class = "p-0",
    shiny::plotOutput("p")
  )
)



shinyUI(

  layout_column_wrap(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    width = 1/2, height = 300,
    card1, card2, card3
  )

  #   anim_width("100%", "67%")
  
    # navbarPage(theme = shinytheme("journal"),
    #            "STAT101 Sites Hub",
    #            
    #            # titlePanel(tags$img(src = "UoC.png", height = 60, width = 400), windowTitle = "Index"),
    #            # selectizeInput(inputId = "Size", label = "Size filter", choices = c("xxxlarge","xxlarge","xlarge","large"), multiple = TRUE, selected = c("xxxlarge", "xxlarge","xlarge","large")),
    #            # selectizeInput(inputId = "Status", label = "Status filter", choices = c("running","sleeping","terminated"), multiple = TRUE, selected = c("running","sleeping")),
    #            # hr(),
    #            # tabsetPanel(
    #            
    #            tabPanel("Completed",
    #                     useShinyjs(),
    #                     img(src="UoC.png", width="25%", align="right"),
    #                     
    #                     tags$h2("Completed Sites for STAT101"),
    #                     withSpinner(
    #                         htmlOutput("LinksComplete", style = "font-size: 20px;")
    #                     )
    #            ),
    #            tabPanel("Completing",
    #                     img(src="UoC.png", width="25%", align="right"),
    #                     tags$h2("Sites for STAT101 to Complete"),
    #                     withSpinner(
    #                         htmlOutput("LinksNotComplete", style = "font-size: 20px;")
    #                     )
    #            )
    #            
    #            # tabPanel("Data423", 
    #            #          tags$h2("Data Science in Industry"),
    #            #          withSpinner(
    #            #              htmlOutput("Data423Links")
    #            #          )
    #            # ),
    #            # tabPanel("Data101/401",
    #            #          tags$h2("Introduction to Data Science"),
    #            #          withSpinner(
    #            #              htmlOutput("Data101Links")
    #            #          )
    #            # ),
    #            # tabPanel("Misc",
    #            #          tags$h2("Miscellaneous"),
    #            #          withSpinner(
    #            #            htmlOutput("MiscLinks")
    #            #          )
    #            # )
    # )

)
