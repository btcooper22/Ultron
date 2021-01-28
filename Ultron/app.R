# FUll randomisation
# Control film options
# Control number within each category
# Render images

# Packages
require(shiny)
require(dplyr)
require(shinyWidgets)

# Data (for deployment)
rules <- read.csv("UltronRules.csv")

# Data (for testing)
# rules <- read.csv("Ultron/UltronRules.csv")

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Ultron: A Marvel Drinking Game Generator"),

    sidebarLayout(
        sidebarPanel(
            helpText("Select films to include or exclude in the randomisation:"),
            
            pickerInput("film", "Films:",
                        choices = unique(rules$Film),
                        multiple = TRUE, width = "auto", 
                        options = list(`actions-box` = TRUE)),
            
            sliderInput("range", 
                        label = "Range of interest:",
                        min = 0, max = 100, value = c(0, 100)),
            actionButton("goButton","Randomize!")
        ),
        
        mainPanel(
            textOutput("selected_var"),
            textOutput("min_max")
        )
    )
)

# Debug
#input <- data.frame(film = unique(rules$Film))

# Define server logic 
server <- function(input, output) {
    # Generate film
    film <- eventReactive(input$goButton, {
        sample(input$film,1)
    })
    
    
    output$selected_var <- renderText({ 
        paste("Your film is", film())
    })
    
    output$min_max <- renderText({ 
        paste("You have chosen a range that goes from",
              input$range[1], "to", input$range[2])
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
