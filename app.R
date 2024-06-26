if (FALSE) { # rlang::is_interactive()
  library(shiny)
  library(bslib)
  
  link_shiny <- tags$a(
    shiny::icon("github"), "Shiny",
    href = "https://github.com/rstudio/shiny",
    target = "_blank"
  )
  link_posit <- tags$a(
    shiny::icon("r-project"), "Posit",
    href = "https://posit.co",
    target = "_blank"
  )
  
  ui <- page_navbar(
    title = "My App",
    nav_panel(title = "One", p("First page content.")),
    nav_panel(title = "Two", p("Second page content.")),
    nav_panel("Three", p("Third page content.")),
    nav_spacer(),
    nav_menu(
      title = "Links",
      align = "right",
      nav_item(link_shiny),
      nav_item(link_posit)
    )
  )
  
  server <- function(input, output, session) { } # not used in this example
  
  shinyApp(ui, server)
}



####################################
## alert minimum
# 
# library(shiny)
# library(shinyalert)
# 
# # Define UI
# ui <- fluidPage(
#   useShinyalert(),  # Initialize shinyalert
#   titlePanel("Numeric Input Validation"),
#   sidebarLayout(
#     sidebarPanel(
#       numericInput("num1", "Number 1:", value = 0, min = 0),
#       numericInput("num2", "Number 2:", value = 0, min = 0),
#       actionButton("update_btn", "Update")
#     ),
#     mainPanel(
#       textOutput("result")
#     )
#   )
# )
# 
# # Define server logic
# server <- function(input, output, session) {
#   
#   # Observer to check the numeric input values when the button is clicked
#   observeEvent(input$update_btn, {
#     req(input$num1, input$num2)  # Ensure both inputs are available
#     
#     if (input$num1 >= input$num2) {
#       shinyalert(
#         title = "Error",
#         text = "Number 1 should be less than Number 2.",
#         type = "error"
#       )
#     }
#   })
#   
#   output$result <- renderText({
#     paste("Number 1:", input$num1, "Number 2:", input$num2)
#   })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)

###############################################################################
### minimum layout
# library(shiny)
# library(bslib)
# library(plotly)
# 
# # Define UI
# ui <- page_fillable(
#   theme = bs_theme(), # You can customize your bslib theme here
#   # card(
#   navset_pill(
#     nav_menu(
#       title = "level 1",
#       nav_panel(title = "1a", 
#                 layout_sidebar(
#                   sidebar = div(
#                     style = "height: 600px; overflow-y: auto;",
#                     sidebar(
#                       h4("Left Sidebar content"),
#                       p("Sidebar information"),
#                       actionButton("button1", "Click me"),
#                       sliderInput("slider", "Slider input:", min = 1, max = 100, value = 50),
#                       selectInput("select", "Select input:", choices = c("Option 1", "Option 2", "Option 3")),
#                       checkboxGroupInput("checkbox", "Checkbox group:", choices = c("Checkbox 1", "Checkbox 2", "Checkbox 3")),
#                       actionButton("button2", "Another button"),
#                       p("Some more text to make the sidebar longer."),
#                       textInput("text", "Text input:"),
#                       dateInput("date", "Date input:"),
#                       numericInput("numeric", "Numeric input:", value = 10, min = 1, max = 100),
#                       actionButton("button3", "Yet another button")
#                     )
#                   ),
#                   navset_card_pill(
#                     placement = "above",
#                     nav_panel(
#                       title = "2a",
#                       layout_sidebar(
#                         sidebar = sidebar(
#                           h4("Right Sidebar content"),
#                           p("Right sidebar information"),
#                           actionButton("right_button1", "Click me"),
#                           sliderInput("right_slider", "Right Sidebar Slider:", min = 1, max = 100, value = 50),
#                           selectInput("right_select", "Right Sidebar Select:", choices = c("Option A", "Option B", "Option C")),
#                           checkboxGroupInput("right_checkbox", "Right Sidebar Checkboxes:", choices = c("Checkbox A", "Checkbox B", "Checkbox C")),
#                           actionButton("right_button2", "Another button"),
#                           p("Some more text to make the right sidebar longer."),
#                           textInput("right_text", "Right Sidebar Text input:"),
#                           dateInput("right_date", "Right Sidebar Date input:"),
#                           numericInput("right_numeric", "Right Sidebar Numeric input:", value = 10, min = 1, max = 100),
#                           actionButton("right_button3", "Yet another button"),
#                           position = "right"
#                         ),
#                         div(
#                           plotlyOutput("plot", height = "400px"),
#                           p("Other main content below the plot."),
#                           style = "height: 400px;"
#                         )
#                       )
#                     ),
#                     nav_panel(title = "2b"),
#                     nav_panel(title = "2c"),
#                   )
#                 )
#       ),
#       nav_panel(title = "1b"),
#       nav_panel(title = "1c"),
#     )
#   )
#   # )
# )
# 
# 
# # Define server logic
# server <- function(input, output, session) {
#   output$plot <- renderPlotly({
#     plot_ly(
#       data = iris,
#       x = ~Sepal.Length,
#       y = ~Sepal.Width,
#       type = "scatter",
#       mode = "markers"
#     )
#   })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)
