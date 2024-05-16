library(shiny)
library(shinyjs)
library(shinycssloaders)
library(shinythemes)
library(bslib)
library(bsicons)


card1 <- card(
  full_screen = TRUE,
  card_header(class = "bg-primary", "Card 1"),
  card_body(#class = "text-primary",
    withSpinner(
      htmlOutput("LinksComplete", style = "font-size: 20px;")
    )
  )
  # "This is it1."
  # lapply(
  #   lorem::ipsum(paragraphs = 3, sentences = c(5, 5, 5)),
  #   tags$p
  # )
)
card2 <- card(
  full_screen = TRUE,
  card_header(class = "bg-secondary", "Card 2"),
  markdown("- Three 
                 - Four")
)
card3 <- card(
  # class="card border-danger mb-0",

  full_screen = TRUE,
  card_header(class = "bg-success", "Card 3"),
  markdown("- 5 - 6")
  
)
card4 <- card(
  full_screen = TRUE,
  card_header(class = "bg-info", "Card 4"),
  markdown("- 7 
                 - 8")
)
card5 <- card(
  full_screen = TRUE,
  card_header(class = "bg-warning", "Card 5"),
  markdown("- 9 
                 - 10")
)

card6 <- card(
  full_screen = TRUE,
  card_header( "Card 6" #class = "bg-danger",
               ),
  # card_image(
  #   file = "www/UoC.png",
  #   href = "https://github.com/rstudio/shiny"
  # ),
  markdown("- 11
                 - 12")
)
# card3 <- card(
#   full_screen = TRUE,
#   card_header("Filling content"),
#   # "This is it3."
#   card_body(
#     class = "p-0",
#     shiny::plotOutput("p")
#   )
# )


shinyUI(
  
  page_fillable(
    # title = "STAT101 Page",
    theme = bs_theme(bootswatch = "united"),
    fillable_mobile = TRUE,
    
    layout_column_wrap(  
      # theme = bs_theme(bootswatch = "united"),
      width = 1/2, fill = TRUE,
      fillable = FALSE,
      headerPanel("STAT101 Page"),
      img(src="UoC.png", align="right", style="aspect-ratio: auto; max-height: 60px"),
      
    ),
    layout_column_wrap(  
      # theme = bs_theme(bootswatch = "united"),
      width = 1/3, #height = 300,
      card1, card2, card3, card4, card5, card6
    )
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
