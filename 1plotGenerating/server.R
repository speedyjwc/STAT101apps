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
  
  #############################################################################################
  #############################################################################################
  #############################################################################################
  ### accordions behaviour for 0ne numeric variable
  
  
  # buttons that control expand/collapse all accordions
  observeEvent(input$isNum1Expand,{
    accordion_panel_open(id = "sideAccordionNum1", values = TRUE)
  })
  
  observeEvent(input$isNum1Collapse,{
    accordion_panel_close(id = "sideAccordionNum1", values = TRUE)
  })
  
  
  #############################################################################################
  #############################################################################################
  #############################################################################################
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
    "Upload a csv file and select a quantitative variable!"
  })
  
  # make messageBox1 disappear once the file is uploaded
  observe({
    toggleElement(id = "messageBox1",
                  condition = is.null(input$file1))
  })
  
  # display raw data as DT
  output$contents_raw <- renderDataTable(
    # df_raw(), 
    datatable(df_raw(), options = list(scrollX=TRUE))
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
  
  #############################################################################################
  #############################################################################################
  ## updateplotButton behaviours FOR BOXPLOT
  
  # store the x-axis label value when update button FOR BOXPLOT is clicked
  xLabBox <- eventReactive(input$updateBoxPlotButton, {
    input$xLab1Num
  })
  
  observe({
    updateTextInput(session, inputId = "xLabBox", value = input$num1)
  })
  
  # store the y-axis label value when update button FOR BOXPLOT is clicked
  yLabBox <- eventReactive(input$updateBoxPlotButton, {
    input$yLab1Num
  })
  
  # store the title value when update button FOR BOXPLOT is clicked
  titleBox <- eventReactive(input$updateBoxPlotButton, {
    input$title1Num
  })
  
  # store the plot width value when update button FOR BOXPLOT is clicked  
  plotWidthBox <- eventReactive(input$updateBoxPlotButton, {
    input$plotWidth
  })
  
  # store the plot height value when update button FOR BOXPLOT is clicked  
  plotHeightBox <- eventReactive(input$updateBoxPlotButton, {
    input$plotHeight
  })
  
  #############################################################################################
  #############################################################################################
  ## reset button behaviours FOR BOXPLOT
  
  observeEvent(input$resetBoxPlotButton, {
    # universal one num settings
    colourpicker::updateColourInput(session, "colFill", value = "salmon")
    colourpicker::updateColourInput(session, "colBackground", value = "#e5ecf6")
    colourpicker::updateColourInput(session, "colBackLine", value = "black")
    updateTextInput(session, "titleBox", value = " ")
    updateTextInput(session, "xLabBox", value = input$num1)
    updateTextInput(session, "yLabBox", value = " ")
    updateNumericInput(session, "plotHeight", value = NA)
    updateNumericInput(session, "plotWidth", value = NA)
    updateAwesomeCheckboxGroup(session, "grids", selected = c("X", "Y"))
    updatePrettyCheckbox(session, "num1ShowMean", value = TRUE)
    
    # boxplot only settings
    # default value was set to TRUE, horizontal
    updateMaterialSwitch(session, "num1orientationBox", value = TRUE)
  })
  
  
  #############################################################################################
  #############################################################################################
  ## draw the box plot
  
  boxplot <- eventReactive(input$updateBoxPlotButton, {
    df = df_raw()[c(input$num1)]
    
    xyValues <- if(input$num1orientationBox){
      # default value was set to TRUE, the layout for box is horizontal
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
                          width = plotWidthBox(), 
                          height = plotHeightBox()) %>% 
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
      layout(plot_bgcolor = input$colBackground, #'#e5ecf6',
             title = titleBox(),
             xaxis = list(title = xLabBox(),
                          showgrid = "X" %in% input$grids,
                          gridcolor = 'ffff',
                          showticklabels = input$num1orientationBox
             ),
             yaxis = list(gridcolor = 'ffff',
                          showgrid = "Y" %in% input$grids,
                          title = yLabBox(),
                          ticklen = 0,
                          showticklabels = !input$num1orientationBox
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
  
  
  output$test <- renderPrint({
    list(boxplot()$width, histPlot()[[1]]$width)
    
  })
  
  #############################################################################################
  #############################################################################################
  ## updateplotButton behaviours FOR HISTOGRAM
  
  # store the x-axis label value when update button FOR HISTOGRAM is clicked
  xLabHist <- eventReactive(input$updateHistPlotButton, {
    input$xLab1Num
  })
  
  # observe({
  #   updateTextInput(session, inputId = "xLabBox", value = input$num1)
  # })
  
  # store the y-axis label value when update button FOR HISTOGRAM is clicked
  yLabHist <- eventReactive(input$updateHistPlotButton, {
    input$yLab1Num
  })
  
  # store the title value when update button FOR HISTOGRAM is clicked
  titleHist <- eventReactive(input$updateHistPlotButton, {
    input$title1Num
  })
  
  # store the plot width value when update button FOR HISTOGRAM is clicked  
  plotWidthHist <- eventReactive(input$updateHistPlotButton, {
    input$plotWidth
  })
  
  # store the plot height value when update button FOR HISTOGRAM is clicked  
  plotHeightHist <- eventReactive(input$updateHistPlotButton, {
    input$plotHeight
  })
  
  # take the min from selected column as value for the lower end of the x-axis
  xmin <- reactive({
    req(df_raw())
    selected_column <- input$num1
    return(min(df_raw()[[selected_column]], na.rm = TRUE))
  })
  
  # take the max from selected column as value for the upper end of the x-axis
  xmax <- reactive({
    req(df_raw())
    selected_column <- input$num1
    return(max(df_raw()[[selected_column]], na.rm = TRUE))
  })
  
  # once the csv is uploaded, update the numericInput for xmin
  observeEvent(xmin(), {
    updateNumericInput(session,
                       inputId = "xminHist",
                       value = xmin())
  })
  
  # once the csv is uploaded, update the numericInput for xmax
  observeEvent(xmax(), {
    updateNumericInput(session,
                       inputId = "xmaxHist",
                       value = xmax())
  })
  
  # default settings button for histogram:
  observeEvent(input$resetHistPlotButton, {
    # universal one num settings
    colourpicker::updateColourInput(session, "colFill", value = "salmon")
    colourpicker::updateColourInput(session, "colBackground", value = "#e5ecf6")
    colourpicker::updateColourInput(session, "colBackLine", value = "black")
    updateTextInput(session, "titleBox", value = " ")
    updateTextInput(session, "xLabBox", value = input$num1)
    updateTextInput(session, "yLabBox", value = " ")
    updateNumericInput(session, "plotHeight", value = NA)
    updateNumericInput(session, "plotWidth", value = NA)
    updateAwesomeCheckboxGroup(session, "grids", selected = c("X", "Y"))
    # default value was set to TRUE, horizontal
    updatePrettyCheckbox(session, "num1ShowMean", value = TRUE)
    
    #histogram only settings
    updateSliderInput(session, "histBinNums", value = 10)
    updateNumericInput(session, inputId = "xminHist", value = xmin())
    updateNumericInput(session, inputId = "xmaxHist", value = xmax())
    updateMaterialSwitch(session, inputId = "num1histNicerWidth", value = FALSE)
  })
  
  
  #############################################################################################
  #############################################################################################
  ## draw the histogram
  histPlot <- eventReactive(input$updateHistPlotButton, {
    
    df = df_raw()[c(input$num1)]
    #using ggplot, user can set the bin numbers as they wish but sometimes the bin is not algined to the ticks well
    
    # range = range(df_sub(), na.rm = TRUE)
    #
    # binWidth = (range[2]-range[1])/(input$binNums-1)
    
    axisMin = input$xminHist
    axisMax = input$xmaxHist
    histStep = 10^(floor(
      log10(
        axisMax - axisMin
        # max(df,na.rm = TRUE)-
        #   min(df,na.rm = TRUE)
      )
    )-1)
    
    if (input$num1histNicerWidth){
      axisEnd = ceiling(axisMax/histStep)*histStep
      axisStart = floor(axisMin/histStep)*histStep
    } else {
      axisEnd = axisMax
      axisStart = axisMin
    }
    
    hist <- ggplot(data = df, mapping = aes_string(x = names(df)[1])) +
      geom_histogram( breaks = seq(
        axisStart, axisEnd, 
        length.out = input$histBinNums+1),
                      # bins = input$binNums,
                      fill = input$colFill, color = input$colLine) +
      theme(
        plot.margin = margin(0.7, 0.2, 0.2, 0.2, "cm"),
        panel.grid=element_blank()
      )

    aa <- ggplotly(hist) %>% layout(width=plotWidthHist(), height=plotHeightHist())
    axisSeq <- seq(min(aa$x$data[[1]]$x-aa$x$data[[1]]$width/2),
                max(aa$x$data[[1]]$x+aa$x$data[[1]]$width/2),
                by = max(round(input$histBinNums/10),1)*aa$x$data[[1]]$width[1])
    
    plotHist <- aa %>%
      style(hoverinfo = 'none') %>%
      add_trace(x=aa$x$data[[1]]$x,
                y=aa$x$data[[1]]$y,
                color = I(input$colFill),
                alpha = 0.01,
                type = 'bar',
                text = paste0(
                  # "range: (", round(aa$x$data[[1]]$x-aa$x$data[[1]]$width/2, 2), ", ",
                  # round(aa$x$data[[1]]$x+aa$x$data[[1]]$width/2, 2), "]", 
                  # "<br>frequency: ", aa$x$data[[1]]$y
                  "lower bound: ", round(aa$x$data[[1]]$x-aa$x$data[[1]]$width/2, 2),
                  "<br>upper bound: ", round(aa$x$data[[1]]$x+aa$x$data[[1]]$width/2, 2),
                  "<br>frequency: ", aa$x$data[[1]]$y
                ),
                hoverinfo="text") %>%
      layout(plot_bgcolor = input$colBackground, #'#e5ecf6',
             title = titleHist(),
             xaxis = list(
               title = xLabHist(),
               ticks="inside",
               ticktext = round(axisSeq,1),
               tickvals = axisSeq,
               tickmode = "array",
               tickangle = 45,
               showgrid = "X" %in% input$grids,
               gridcolor = 'ffff'
             ),
             yaxis = list(
               title = yLabHist(),
               gridcolor = 'ffff',
               showgrid = "Y" %in% input$grids,
               title = "Frequency",
               ticktext = round(seq(0, max(aa$x$data[[1]]$y),length.out = 6)),
               tickvals = seq(0, max(aa$x$data[[1]]$y),length.out = 6),
               tickmode = "array")
      ) %>%
      config(modeBarButtons = list(list("toImage")),
             displaylogo = FALSE)
    # 
    # plotHist$width <- plotWidthHist()
    # plotHist$height <- plotHeightHist()
    return(list(plotHist, histStep))
    
  })
  
  output$histGgplot <- renderPlotly({
    histPlot()[[1]]
  })
  
  
  
})

