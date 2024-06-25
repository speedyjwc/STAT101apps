library(shiny)
library(bslib)
library(bsicons)
library(shinyWidgets)
library(DT)
library(colourpicker)
library(plotly)
library(shinyjs)

# Define UI 
shinyUI(
  # tags$head(
  page_fillable(
    padding = 0,
    theme = bs_theme(version = 5,
                     bootswatch = "united",
                     #                  # "accordion-title-color" = "green",
                     #                  heading_font = font_google("Josefin Slab")
    ),
    title = NULL,
    
    # need this as the container for page_fillable()?
    card(
      
      # alternative way to customise the accordion titles
      tags$style(HTML(
        ".accordion-title{
                          /*customise the title font style(bold, font family and italic)*/
                          /*color: green;*/
                          font-weight: 900;
                          font-style: italic;
                          font-family: 'Josefin Slab', 'Courier New', monospace;
                          /*add a green underline*/
                          text-decoration-line: underline;
                          text-decoration-color: green;
        }
        .sidebar{
                  height: 600px; 
                  overflow-y: auto;
        
        }
                                 
               ")),
      # allows the toggleElement to work
      useShinyjs(),
      
      navset_pill(
        # title for each panel was too long for tab/pill, generate a menu to host them
        nav_menu(
          title = "Select the number of variable and the type",
          nav_panel(title = "One Quantitative Variable", 
                    icon = bs_icon("1-circle-fill"),
                   
                    
                    # p("One Quantitative variable."),
                    # verbatimTextOutput("test"),
                    # the left side bar for one num universal settings
                    layout_sidebar(
                      max_height = "600px",
                      sidebar = sidebar(
                        # Use accordion layout
                        accordion(
                          id = "sideAccordionNum1",
                          layout_columns(
                            col_widths = c(6, 6),
                            actionBttn(
                              inputId = "isNum1Expand",
                              label = "Expand all",
                              style = "float",
                              color = "primary",
                              size = "sm"
                            ),
                            actionBttn(
                              inputId = "isNum1Collapse",
                              label = "Collapse all",
                              style = "float",
                              color = "primary",
                              size = "sm"
                            )
                          ),
                          
                          # accordion 1, upload file
                          accordion_panel( 
                            # suppose to use "value" to identify each panel
                            value = "acc_file",
                            "Upload File",
                            icon = bs_icon("upload"),
                            # Input: Select a file ----
                            fileInput(
                              "file1",
                              "Choose CSV File:",
                              multiple = TRUE,
                              accept = c(
                                "text/csv",
                                "text/comma-separated-values,text/plain",
                                ".csv"
                              )
                            ),
                            
                            # Input: Checkbox if file has header ----
                            checkboxInput("header", "Header", TRUE),
                            
                            # Input: Select separator ----
                            radioButtons(
                              "sep",
                              "Separator:",
                              choices = c(
                                Comma = ",",
                                Semicolon = ";",
                                Tab = "\t"
                              ),
                              selected = ","
                            ),
                            
                            # Input: Select quotes ----
                            radioButtons(
                              "quote",
                              "Quote:",
                              choices = c(
                                None = "",
                                "Double Quote" = '"',
                                "Single Quote" = "'"
                              ),
                              selected = '"'
                            ),
                            
                          ), # accordion_panel 1 upload file
                          
                          # accordion 2, variable selection
                          accordion_panel(
                            value = "acc_boxplot_setting",
                            icon = bs_icon("brush"), #"hand-index-thumb"
                            "Plot Settings",
                            open = FALSE,
                            pickerInput(
                              inputId = "num1",
                              label = "Choose a quantitative variable:", 
                              choices = "Upload the csv file first",
                              options = list(
                                `live-search` = TRUE,
                                size = 5)
                            ),
                            
                            conditionalPanel(
                              condition = "input.num1 != 'Upload the csv file first'",
                              hr(),
                              p("Customised Labeling:"),
                              textInput("title1Num", label = "Title:  ", " "),
                              # x axis
                              textInput(inputId = "xLab1Num", 
                                        label = "X Label:", 
                                        value = "X axis is..."),
                              # y axis
                              textInput("yLab1Num", "Y Label:", " "),
                              hr(),
                              colourpicker::colourInput(inputId = "colFill", 
                                                        label = "Color for the filling:", 
                                                        value = "salmon"),
                              
                              colourpicker::colourInput(inputId = "colBackground", 
                                                        label = "Colour for the backbround:", 
                                                        value = '#e5ecf6'),
                              colourpicker::colourInput(inputId = "colLine", 
                                                        label = "Color for the line:", 
                                                        value = 'black'),
                              hr(),
                              awesomeCheckboxGroup(
                                inputId = "grids",
                                label = "Show Grids on: ", 
                                choices = c("X", "Y"),
                                selected = c("X", "Y"),
                                inline = TRUE
                                # status = "danger"
                              ),
                              hr(),
                              
                              numericInput(
                                inputId = "plotWidth",
                                label = "Plot width in pixel:",
                                value = NA,
                                min = 100,
                                step = 1
                              ),
                              numericInput(
                                inputId = "plotHeight",
                                label = "Plot height in pixel:",
                                value = NA,
                                min = 100,
                                step = 1
                              ),
                              hr(),
                              prettyCheckbox(
                                inputId = "num1ShowMean",
                                label = "Show mean", 
                                value = TRUE,
                                status = "danger",
                                shape = "curve"
                              )
                            ) # conditional panel
                          ) # accordion_panel 2, setting inputs
                        ) # accordion wrap
                      ), # side bar wrap
                      
                      # one numeric main content
                      navset_card_pill(
                        id = "output_opts",
                        placement = "above",
                        # full_screen = TRUE,
                         
                        nav_panel(

                          title = "Raw data",
                          textOutput("messageBox1"),
                          tags$head(tags$style(
                            "#messageBox1{
                        color: black;
                        font-size: 20px;
                        font-style: italic;}"
                          )
                          ),
                          
                          br(),
                          # Output: Data file ----
                          DT::DTOutput("contents_raw")
                        ),
                        nav_panel(
                          title = "Boxplot",
                          # side bar on the right for boxplot(one num) only
                          layout_sidebar(
                            sidebar = sidebar(
                              materialSwitch(
                                inputId = "num1orientationBox",
                                label = "Switch the layout orientation:",
                                value = TRUE,
                                status = "danger"
                              ),
                              hr(),
                              position = "right", 
                              open = TRUE),
                            layout_column_wrap(
                              width = 1/3,
                              max_height = "25px",
                              actionButton("updateBoxPlotButton",
                                           "Update Plot",
                                           icon("list-check"),
                                           # width = "20%"
                              ),
                              actionButton("resetBoxPlotButton",
                                           "Default settings",
                                           icon("refresh"),
                                           # width = "20%"
                              ),
                            ),
                            div(
                              # style = htmltools::css(
                              #   # margin_top = '10px',
                              #   # vertical_align = 'top'
                              # ),
                              plotlyOutput("boxPlot"),
                              align = "center"
                            ),
                            border = FALSE
                          ),
                        ),
                        nav_panel(
                          title = "Histogram", 
                          # side bar on the right for histogram(one num) only
                          layout_sidebar(
                            sidebar = sidebar(
                              sliderInput(inputId = "histBinNums", 
                                          label = "Number of bins: ",
                                          min = 5,
                                          max = 50,
                                          step = 1,
                                          value = 10),
                              numericInput(
                                inputId = "xminHist",
                                label = "Set minimum:",
                                value = NA),
                              numericInput(
                                inputId = "xmaxHist",
                                label = "Set maximum:",
                                value = NA),
                              materialSwitch(
                                inputId = "num1histNicerWidth",
                                label = '"Nicer" bin width:',
                                value = FALSE,
                                status = "danger"
                              ),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              hr(),
                              em("All the upper bound of the bins are inclusive and all (except for the first bin) the lower bound of the bins are exclusive."),
                              
                              position = "right", 
                              open = TRUE),
                            layout_column_wrap(
                              width = 1/3,
                              max_height = "25px",
                              actionButton("updateHistPlotButton", 
                                           "Update Plot", 
                                           icon("list-check"),
                                           # width = "20%"
                              ),
                              actionButton("resetHistPlotButton", 
                                           "Default settings", 
                                           icon("refresh"),
                                           # width = "20%"
                              ),
                            ),
                            div(
                              # style = htmltools::css(
                              #   margin_top = '10px',
                              # ),
                              plotlyOutput("histGgplot"),
                              align = "center"
                            ),
                            border = FALSE
                          ),
                          
                        ),
                        nav_panel(title = "Dotplot", 
                                  p("plot 3 content.")),
                        
                        nav_panel(title = "Summary", 
                                  # combined in datatable tab?
                                  p("Summary statistic content")),
                        nav_spacer(),
                        nav_item(
                          p(style = "font-weight: 700; font-size: 25px;", "One Quantitative Variable")
                          
                        ),
                        
                        
                      ) # navset_card_pill wrap one numeric main content
                    ) # layout_sidebar wrap?
                    
          ),
          nav_panel(title = "One Categorical Variable", 
                    icon = bs_icon("2-circle-fill"),
                    p("Second tab content."),
                    # navset_card_pill(
                    #   placement = "below",
                    #   nav_panel(title = "One",
                    #             p("First tab content."),
                    #             #             # Output: Data file ----
                    #             tableOutput("contents")),
                    #   nav_panel(title = "Two", 
                    #             p("Second tab content.")),
                    #   nav_panel(title = "Three", 
                    #             p("Third tab content")),
                    #   
                    # )
                    
                    
                    
          ),
          nav_panel(title = "One Quantitative and One Categorical Variable",
                    icon = bs_icon("3-circle-fill"),
                    p("One Quantitative and One Categorical Variable content")
          ),
          nav_panel(title = "Two Categorical Variables", 
                    icon = bs_icon("4-circle-fill"),
                    p("Two Categorical Variables content")
          ),
          nav_panel(title = "Two Quantitative Variables", 
                    icon = bs_icon("5-circle-fill"),
                    p("Two Quantitative Variables content")),
        ),
        nav_spacer(),
        nav_item(img(src="UoC.png", style="aspect-ratio: auto; max-height: 60px")),
        nav_menu(
          title = "Other sites",
          nav_item("    Sampling"),
          nav_item("    Bootstrap"),
          nav_item("    Randomisation"),
          nav_item("    ...")
        )
        
      ),
      
      
      # nav_panel(title = "Two", p("Second tab content.")),
      # 
      # nav_panel(title = "Three", p("Third tab content")),
      # 
      # nav_spacer(),
      # nav_menu(
      #   title = "Links",
      #   # nav_item(link_shiny),
      #   # nav_item(link_posit)
      # )
      
    ) # wrap for the card()
    
  )
)
