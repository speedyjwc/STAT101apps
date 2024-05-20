library(shiny)
library(bslib)
library(bsicons)
library(shinyWidgets)

# Define UI 
shinyUI(
  page_fillable(
    padding = 0,
    theme = bs_theme(version = 5, bootswatch = "united"),
    
    # sidebar for all types/numbers of variable
    layout_sidebar(
      
      # Sidebar panel for inputs ----
      sidebar = sidebar(

        # Use accordion layout
        accordion(
          id = "sideAcc",
          layout_columns(
            col_widths = c(6, 6),
            actionBttn(
              inputId = "isExpand",
              label = "Expand all",
              style = "float",
              color = "primary",
              size = "sm"
            ),
            actionBttn(
              inputId = "isCollapse",
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
            "Uploading Files",
            icon = bs_icon("upload"),
            # Input: Select a file ----
            fileInput(
              "file1",
              "Choose CSV File",
              multiple = TRUE,
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv"
              )
            ),
 
            
            # # Horizontal line ----
            # tags$hr(),
            
            # Input: Checkbox if file has header ----
            checkboxInput("header", "Header", TRUE),
            
            # Input: Select separator ----
            radioButtons(
              "sep",
              "Separator",
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
              "Quote",
              choices = c(
                None = "",
                "Double Quote" = '"',
                "Single Quote" = "'"
              ),
              selected = '"'
            ),
            
            # # Horizontal line ----
            # tags$hr(),
            # 
            # # Input: Select number of rows to display ----
            # radioButtons(
            #   "disp",
            #   "Display",
            #   choices = c(
            #     Head = "head",
            #     All = "all"
            #   ),
            #   selected = "head"
            # )
          ),

          # accordion 2, variable selection
          accordion_panel(
            value = "acc_var",
            icon = bs_icon("hand-index-thumb"),
            "Variable selection",
            open = FALSE,
            "Choose the variable for visualisiation"
          ),
          
          # accordion 3, plot customise
          accordion_panel(
            value = "acc_plot",
            icon = bs_icon("palette"),
            "Plot editting",
            open = FALSE,
            "Customise the plot"
          )
        )
      ),

      # main content area
      navset_pill(
        # title for each panel was too long for tab/pill, generate a menu to host them
        nav_menu(
          title = "Select the number of variable and the type",
          nav_panel(title = "One Quantitative Variable", 
                    icon = bs_icon("1-circle-fill"),
                    p("First tab content."),
                    verbatimTextOutput("test"),
                    
                    navset_card_pill(
                      placement = "above",
                      nav_panel(
                        title = "Raw data",
                        h4("upload a csv file and select a numerical variable"),
                        br(),
                        # Output: Data file ----
                        dataTableOutput("contents_raw")),
                      nav_panel(
                        
                        title = "Vis1",
                        p("plot 1 content.")
                      ),
                      nav_panel(title = "Vis2", 
                                p("plot 2 content.")),
                      nav_panel(title = "Vis3", 
                                p("plot 3 content.")),
                      
                      nav_panel(title = "Summary", 
                                # combined in datatable tab?
                                p("Summary statistic content")),
                      
                    )
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
      # )
      # )
    )
  )
  
)
