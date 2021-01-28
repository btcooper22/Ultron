# To-do: Render images
# To-do: two-panel output


# Packages
require(shiny)
require(dplyr)
require(tibble)
require(shinyWidgets)

# Functions
firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
}

# Data (for deployment)
rules <- read.csv("UltronRules.csv")

# Data (for testing)
# rules <- read.csv("Ultron/UltronRules.csv")

# Correct capitalisation
rules$Rule <- firstup(rules$Rule)

# Define UI for application
ui <- fluidPage(
    
    # Application title
    titlePanel("Ultron: A Marvel Drinking Game Generator"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Select films to include or exclude in the randomisation:"),
            
            pickerInput("film", "Films:",
                        choices = unique(rules$Film),
                        multiple = TRUE, width = "fit", 
                        options = list(`actions-box` = TRUE,
                                       `selected-text-format` = "count > 1"),
                        selected = unique(rules$Film)),
            
            numericInput("nS", "Small drinks:", min = 0, max = 12, value = 2),
            numericInput("nM", "Medium drinks:", min = 0, max = 8, value = 2),
            numericInput("nL", "Large drinks:", min = 0, max = 6, value = 2),
            actionBttn("goButton","Randomize!",
                       style = "gradient")
        ),
        
        mainPanel(
            textOutput("selected_film"),
            h2("Take a small drink:"),
            htmlOutput("small_drink"),
            h2("Take a medium drink:"),
            htmlOutput("medium_drink"),
            h2("Take a large drink:"),
            htmlOutput("large_drink")
        )
    )
)

# Debug
# input <- data.frame(film = unique(rules$Film),
#                     nS = 2)
# film <-  sample(input$film,1)
# film_rules <- rules %>% 
#     filter(Film == film)

paste("Take a small drink whenever", c("A", "B", "C"))

# Define server logic 
server <- function(input, output) {
    film <- eventReactive(input$goButton, {
        # Generate film
        film_name <- sample(input$film,1)
        
        # Isolate rules
        film_rules <- rules %>% 
            filter(Film == film_name)
        
        # Sample small drinks
        small_drinks <- film_rules %>% 
            filter(Class == "S") %>% 
            slice_sample(n = input$nS) %>% 
            select(Rule) %>% 
            deframe()
        
        # Sample medium drinks
        medium_drinks <- film_rules %>% 
            filter(Class == "M") %>% 
            slice_sample(n = input$nM) %>% 
            select(Rule) %>% 
            deframe()
        
        
        # Sample large drinks
        large_drinks <- film_rules %>% 
            filter(Class == "L") %>% 
            slice_sample(n = input$nL) %>% 
            select(Rule) %>% 
            deframe()
        
        # Return
        list(film_name = film_name,
             small_drinks = small_drinks,
             medium_drinks = medium_drinks,
             large_drinks = large_drinks)
    })
    
    
    output$selected_film <- renderText({ 
        paste("Your film is", film()["film_name"])
    })
    
    output$small_drink <- renderUI({ 
        if(input$nS!=0)
        {
            HTML(paste(film()["small_drinks"] %>% unlist(), 
                       collapse  = "<br/>"))
        }else
        {
            HTML("")
        }
        
    })
    
    output$medium_drink <- renderUI({ 
        if(input$nM!=0)
        {
            HTML(paste(film()["medium_drinks"] %>% unlist(), 
                       collapse  = "<br/>"))
        }else
        {
            HTML("")
        }
    })
    
    output$large_drink <- renderUI({ 
        if(input$nL!=0)
        {
            HTML(paste(film()["large_drinks"] %>% unlist(), 
                       collapse  = "<br/>"))
        }else
        {
            HTML("")
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
