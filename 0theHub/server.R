library(shiny)
library(rsconnect)
library(dplyr)
library(bslib)
library(bsicons)
library(htmltools)

# setAccountInfo(name='uocstats', token='0FD5791A9B518FC10240A45703D5EF0C', secret='a/GOl+b02j3gFjgTlW2jEKDm6eM/VFgZkdpy1tVQ')
rsconnect::setAccountInfo(name='uocstats', token='0FD5791A9B518FC10240A45703D5EF0C', secret='a/GOl+b02j3gFjgTlW2jEKDm6eM/VFgZkdpy1tVQ')

shinyServer(function(input, output) {
  
  ################################################### 
  # get existing apps as a df   
  ###################################################  
  getRawApplications <- reactive({

    d <- rsconnect::applications(account = "uocstats")
    # print(d)
    d %>% 
      dplyr::filter(status %in% c("running", "sleeping")) %>% 
      dplyr::arrange(name)
    # d[order(d$name),]
  })
  ################################################### 
  # generate bulletins with hyper links for completed stat101 sites
  ###################################################   
  # output$LinksComplete <- renderUI({
  #   d <- getRawApplications()
  #   # print(d)
  #   matches <-  grepl(d$name, pattern = "_Stat101", ignore.case = TRUE)
  #   d <- d[matches,]
  #   remove_stat <- substr(d$name,1,nchar(d$name)-8)
  #   replace_ <- gsub("_", " ", remove_stat)
  #   tags$ul(
  #     HTML(paste0("<li><a href=\"", d$url, "\", target=\"_blank\">", replace_, "</a>", collapse = "</li>"))
  #   )
  # })
  
  ################################################### 
  # generate bulletins with hyper links for uncompleted stat101 sites
  ###################################################
  # output$LinksNotComplete <- renderUI({
  #   d <- getRawApplications()
  #   # print(d)
  #   matches <-  grepl(d$name, pattern = "Stat101_", ignore.case = TRUE)
  #   d <- d[matches,]
  #   remove_stat <- substring(d$name,9)
  #   replace_ <- gsub("_", " ", remove_stat)
  #   tags$ul(
  #     HTML(paste0("<li><a href=\"", d$url, "\", target=\"_blank\">", replace_, "</a>", collapse = "</li>"))
  #   )
  # })
  
  ################################################### 
  # generate bulletins with hyper links for non-stat101 sites
  ################################################### 
  # output$MiscLinks <- renderUI({
  #   d <- getApplications()
  #   matches <-  ! grepl(d$name, pattern = "423|Data101|Stat101", ignore.case = TRUE)
  #   d <- d[matches,]
  #   tags$ul(
  #     HTML(paste0("<li><a href=\"", d$url, "\", target=\"_blank\">", d$name, "</a>", collapse = "</li>"))
  #   )
  # })
})

