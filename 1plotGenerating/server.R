
# Define server logic to read selected file ----
shinyServer(function(input, output, session) {
  
  # buttons that control expand/collapse all accordions
  observeEvent(input$isExpand,{
    accordion_panel_open(id = "sideAcc", values = TRUE)
  })

  observeEvent(input$isCollapse,{
    accordion_panel_close(id = "sideAcc", values = TRUE)
  })
  
  df_raw <- reactive({
    req(input$file1)
    tryCatch(
      {
        df <- read.csv(
          input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote
                       )
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    return(df)
  })
  
  # display raw data as DT
  output$contents_raw <- renderDataTable(
    # df_raw(), 
    datatable(df_raw(), options = list(scrollX=TRUE) )
    # ,selection = list(mode = 'single', target = 'column'))
    
  )
})

