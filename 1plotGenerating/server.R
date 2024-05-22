
# Define server logic to read selected file ----
shinyServer(function(input, output, session) {
  
  # buttons that control expand/collapse all accordions
  observeEvent(input$isExpand,{
    accordion_panel_open(id = "sideAcc", values = TRUE)
  })

  observeEvent(input$isCollapse,{
    accordion_panel_close(id = "sideAcc", values = TRUE)
  })
  
  # raw data frame after the csv is uploaded
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
  
  # update the dropdown input for varaible selection
  observe ({
    df_num <- df_raw() %>%
      # only keep the numeric variable (potential issue?)
      select_if(~is.numeric(.x))
    # choices <- c("Choose_Here",names(df_num))
    updatePickerInput(session, inputId = "num1", choices = sort(names(df_num)))
    
  })
  
  # store the x-axis label value when update button is clicked
  xLabBox <- eventReactive(input$updatePlotButton, {
    input$xLabBox
  })
  
  observe({
    updateTextInput(session, inputId = "xLabBox", value = input$num1)
  })
  
  observe({
    updateTextInput(session, inputId = "generatePlotButton", value = input$num1)
    
  })
  
  # store the y-axis label value when update button is clicked
  yLabBox <- eventReactive(input$updatePlotButton, {
    input$yLabBox
  })
  
  # store the title value when update button is clicked
  titleBox <- eventReactive(input$updatePlotButton, {
    input$titleBox
  })
  
  boxplot <- reactive({
    df = df_raw()[c(input$num1)]
    
    # p <- ggplot(df_sub(), aes_string(y = names(df_sub())[1], x = 0)) + 
    p <- ggplot(df, aes_string(y = input$num1, x = 0)) + 
      geom_boxplot() +
      coord_flip()
    
    
    fig <- plotly_build(p)
    
    fig$x$data[[1]]$fillcolor <- input$colBox
    
    fig$x$data[[1]]$marker$opacity <- 0.5
    
    boxOutput <- fig %>% 
      hide_colorbar() %>% 
      add_trace(x = mean(df[,1],na.rm = TRUE), y=0, 
                type = "scatter", mode = "marker",
                marker = list(symbol = "x",
                              size = 10,
                              color = "deepskyblue"),
                hoverinfo = "text",
                text = ~paste("Mean: ",round(mean(df[,1],na.rm = TRUE),2), sep="")) %>% 
      layout(plot_bgcolor='#e5ecf6',
             title = titleBox(),
             xaxis = list(title = xLabBox(),
                          gridcolor = 'ffff'
             ),
             yaxis = list(gridcolor = 'ffff',
                          showgrid = F,
                          title = yLabBox(),
                          ticklen = 0,
                          showticklabels=FALSE
             ) 
      )%>%
      config(modeBarButtons = list(list("toImage")),
             displaylogo = FALSE)
    
    return(boxOutput)
  })
  
  output$boxPlot <- renderPlotly({
    boxplot()
  })
  
  
  
  
})

