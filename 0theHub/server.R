library(shiny)
library(rsconnect)
library(dplyr)
library(bslib)
library(bsicons)
library(htmltools)

# setAccountInfo(name='uocstats', token='0FD5791A9B518FC10240A45703D5EF0C', secret='a/GOl+b02j3gFjgTlW2jEKDm6eM/VFgZkdpy1tVQ')
rsconnect::setAccountInfo(name='uocstats', token='0FD5791A9B518FC10240A45703D5EF0C', secret='a/GOl+b02j3gFjgTlW2jEKDm6eM/VFgZkdpy1tVQ')
shinyServer(function(input, output) {
  anim_width <- function(x, width1, width2) {
    x |> tagAppendAttributes(
      class = "animate-width",
      style = css(
        `--width1` = validateCssUnit(width1),
        `--width2` = validateCssUnit(width2),
      ),
    )
  }

  anim_height <- function(x, height1, height2) {
    # Wrap in a div fixed at the height of height2, so the rest of
    # the content on the page doesn't shift up and down
    div(style = css(height = validateCssUnit(height2)),
        x |> tagAppendAttributes(
          class = "animate-height",
          style = css(
            `--height1` = validateCssUnit(height1),
            `--height2` = validateCssUnit(height2),
          ),
        )
    )
  }
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

