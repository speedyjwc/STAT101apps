library(shiny)
library(bslib)
library(bsicons)
library(shinyWidgets)
library(DT)
library(colourpicker)
library(plotly)
library(tidyverse)
library(shinyjs)
# Define server logic to read selected file ----
shinyServer(function(input, output, session) {
  
  ### accordions behaviour
  # buttons that control expand/collapse all accordions
  observeEvent(input$isExpand,{
    accordion_panel_open(id = "sideAccordion", values = TRUE)
  })
  
  observeEvent(input$isCollapse,{
    accordion_panel_close(id = "sideAccordion", values = TRUE)
  })
  
  
  
  ### once file is uploaded
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
  
  # display a message if user has not upload a file
  output$messageBox1 <- renderText({
    "Upload a csv file and select a numerical variable!"
  })
  
  # make messageBox1 disappear once the file is uploaded
  observe({
    toggleElement(id = "messageBox1",
                  condition = is.null(input$file1))
  })
  
  # display raw data as DT
  output$contents_raw <- renderDataTable(
    # df_raw(), 
    datatable(df_raw(), options = list(scrollX=TRUE) )
    # ,selection = list(mode = 'single', target = 'column'))
  )
  
  # update the dropdown input for variable selection
  observe ({
    df_num <- df_raw() %>%
      # only keep the numeric variable (potential issue?)
      select_if(~is.numeric(.x))
    # choices <- c("Choose_Here",names(df_num))
    updatePickerInput(session, inputId = "num1", choices = sort(names(df_num)))
    
  })
  
  ## updateplotButton behaviours
  # store the x-axis label value when update button is clicked
  xLabBox <- eventReactive(input$updateBoxPlotButton, {
    input$xLabBox
  })
  
  observe({
    updateTextInput(session, inputId = "xLabBox", value = input$num1)
  })
  
  # store the y-axis label value when update button is clicked
  yLabBox <- eventReactive(input$updateBoxPlotButton, {
    input$yLabBox
  })
  
  # store the title value when update button is clicked
  titleBox <- eventReactive(input$updateBoxPlotButton, {
    input$titleBox
  })
  
  # store the plot width value when update button is clicked  
  plotWidth <- eventReactive(input$updateBoxPlotButton, {
    input$plotWidth
  })
  
  # store the plot height value when update button is clicked  
  plotHeight <- eventReactive(input$updateBoxPlotButton, {
    input$plotHeight
  })
  
  
  
  ## reset button behaviours
  observeEvent(input$resetBoxPlotButton, {
    colourpicker::updateColourInput(session, "colFill", value = "salmon")
    colourpicker::updateColourInput(session, "colBackground", value = "#e5ecf6")
    colourpicker::updateColourInput(session, "colBackLine", value = "black")
    updateTextInput(session, "titleBox", value = " ")
    updateTextInput(session, "xLabBox", value = input$num1)
    updateTextInput(session, "yLabBox", value = " ")
    updateNumericInput(session, "plotHeight", value = 400)
    updateNumericInput(session, "plotWidth", value = NA)
    updateAwesomeCheckboxGroup(session, "grids", selected = "X")
    updateRadioGroupButtons(session, "num1orientation", selected = "-H",)
    updatePrettyCheckbox(session, "num1ShowMean", value = TRUE)
  })
  
  
  ## draw the box plot
  boxplot <- eventReactive(input$updateBoxPlotButton, {
    df = df_raw()[c(input$num1)]
    
    xyValues <- if(input$num1orientation != "|V"){
      # horizontal settings
      list(boxX = df[,1], 
           meanX = mean(df[,1],na.rm = TRUE),
           boxY = input$num1,
           meanY = input$num1,
           info = "x")
    } else {
      # vertical settings
      list(boxX = input$num1,
           meanX = input$num1,
           boxY = df[,1], 
           meanY = mean(df[,1],na.rm = TRUE),
           info = "y"
      )
    }
    
    
    boxOutput <-  plot_ly(type = "box", 
                          width = plotWidth(), 
                          height = plotHeight()) %>% 
      # the box
      add_boxplot(x = xyValues$boxX, 
                  # can without a y value for the box itself, but with it can be helpful for the mean point
                  y = xyValues$boxY,
                  boxpoints = 'outliers',
                  jitter = 0.5,
                  pointpos = 0,
                  line = list(color = input$colLine),
                  fillcolor = input$colFill,
                  quartilemethod = tolower(input$num1BoxAlgorithm),
                  showlegend = FALSE,
                  # to scrap off the "trace 0" tag
                  hoverinfo = xyValues$info
                  
      )%>% 
      # hide_colorbar() %>% 
      # add the mean as a cross
      {if(input$num1ShowMean){
        add_trace(., x = xyValues$meanX,  
                  # need to set the y value to make this point overlay on the box
                  y = xyValues$meanY,
                  type = "scatter", mode = "marker",
                  marker = list(symbol = "x",
                                size = 10,
                                color = "deepskyblue"),
                  showlegend = FALSE,
                  hoverinfo = "text",
                  text = ~paste("Mean: ",round(mean(df[,1],na.rm = TRUE),2), sep="")
        )} else {.}
      } %>% 
      layout(plot_bgcolor= input$colBackground, #'#e5ecf6',
             title = titleBox(),
             xaxis = list(title = xLabBox(),
                          showgrid = "X" %in% input$grids,
                          gridcolor = 'ffff',
                          showticklabels = input$num1orientation == "-H"
             ),
             yaxis = list(gridcolor = 'ffff',
                          showgrid = "Y" %in% input$grids,
                          title = yLabBox(),
                          ticklen = 0,
                          showticklabels = input$num1orientation == "|V"
             ),
             margin = list(
               l = 50,
               r = 50,
               b = 50,
               t = 75,
               pad = 20
             )
      )%>%
      config(modeBarButtons = list(list("toImage")),
             displaylogo = FALSE)
    
    return(boxOutput)
  })
  
  output$boxPlot <- renderPlotly({
    boxplot()
  })
  
  
  # output$test <- renderPrint({
  #   input$num1BoxGrids
  # 
  # })
  
})

