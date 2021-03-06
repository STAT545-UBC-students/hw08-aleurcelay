library(shiny)
library(ggplot2)
library(dplyr)
library(shinythemes)
library(colourpicker)
library(shinyWidgets)
library(rsconnect)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  theme = shinytheme("united"),
  titlePanel("BC Liquor Store prices"),
  img(src = "BClogo.png", height = 52.25, width = 500, align = "right"), #add logo image
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(0, 35), pre = "$"),
      setSliderColor("Crimson", 1), #change slider color to logo color
      #allow to select more than one type
      checkboxGroupInput("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "BEER",
                   inline = TRUE,
                   ),
      #Show prodcuts from all countries, but allow user to select specific country
      checkboxInput("countryFilter", "Filter by country of origin", FALSE),
      conditionalPanel(
        condition = "input.countryFilter",
        uiOutput("countryOutput")
        ),
      #Let the user filter by sweetness level
      conditionalPanel(
        condition = "input.typeInput =='WINE'",
        uiOutput("sweetOutput")
      ),
      #Select default colors for each type, but let the user decide the colors for the plot
        colourInput("col1", "Beers", "sandybrown", allowTransparent = TRUE, palette = "square", returnName = TRUE),
        colourInput("col2", "Refreshments", "steelblue1", allowTransparent = TRUE,palette = "square", returnName = TRUE),
        colourInput("col3", "Spirits", "indianred1", allowTransparent = TRUE,palette = "square", returnName = TRUE),
        colourInput("col4", "Wine", "darkmagenta", allowTransparent = TRUE,palette = "square", returnName = TRUE)
    ),
    mainPanel(
      textOutput("optionsText"),#to show options found with user selection
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
    filtered <- bcl
    
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    if(is.null(input$typeInput)){
      return(NULL) #avoid an error when no type is selected
    }
    

    #Filter type
    filtered <- filter(filtered, Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput)
    
    #Filter by country if the user chooses to do so
     filtered <- filter(filtered, if(input$countryFilter){
             Country == input$countryInput
     }
     else {Country == Country})
           
  })
  
  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return(NULL)
    }
    #Assign colors to the types
    cols <- c("BEER" = input$col1, "REFRESHMENT" = input$col2, "SPIRITS" = input$col3, "WINE" = input$col4)
    ggplot(filtered(), aes(Alcohol_Content, fill = Type)) +
      geom_histogram(color = "black") +
      scale_fill_manual(values=cols) +
      #change and adjust axis labels
      labs(x = "Alcohol Content (%)", y = "Number of Products")+ 
      theme(axis.text = element_text(size = 18), 
            axis.title=element_text(size=19))
  })
  
  output$results <- DT::renderDataTable({
    filtered()
  })
  
  output$optionsText <- renderText({
    optionsNumber <- nrow(filtered())
    if (is.null(optionsNumber)) {
      optionsNumber <- 0
    }
    paste("We found", optionsNumber, "options to get you tipsy ☺")
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
