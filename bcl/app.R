library(shiny)
library(ggplot2)
library(dplyr)
library(shinyjs)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  img(src = "BClogo.png", height = 52.25, width = 500, align = "right"), #add logo
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(0, 35), pre = "$"),
      #allow to select more than one type
      checkboxGroupInput("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "BEER",
                   inline = TRUE,
                   ),
      uiOutput("countryOutput")
    ),
    mainPanel(
      textOutput("optionsText"),#outputs options found with user selection
      #customize text output
      tags$head(tags$style("#optionsText{color: #DC143C;
                                 font-size: 25px;
                                 font-style: bold;
                                 }"
      )
    ),
      downloadButton("download", "Download options"), #download the options found
      plotOutput("coolplot"),
      br(), br(),
      DT::dataTableOutput("results") #make table interactive
      )
    )
  )


server <- function(input, output) {
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })  
  
  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    if(is.null(input$typeInput)){
      return(NULL) #avoid an error when no type is selected
    }
    
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
  })
  
  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return(NULL)
    }
    ggplot(filtered(), aes(Alcohol_Content, fill = Type)) +
      geom_histogram() +
      labs(x = "Alcohol Content (%)")
  })
  
  output$results <- DT::renderDataTable({
    filtered()
  })
  
  output$optionsText <- renderText({
    optionsNumber <- nrow(filtered())
    if (is.null(optionsNumber)) {
      optionsNumber <- 0
    }
    paste("We found", optionsNumber, "options to get you tipsy")
  })
  
  output$download <- downloadHandler(
    filename = function() {
      "bcl-options.csv"
    },
    content = function(con) {
      write.csv(filtered(), con)
    }
  )
}

shinyApp(ui = ui, server = server)
