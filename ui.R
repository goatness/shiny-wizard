library(shiny)



# Define UI for dataset viewer application
shinyUI(pageWithSidebar(

  # Application title.
  headerPanel("John Wall So Hard WL Stats"),

  # Sidebar with controls to select a dataset and specify the number
  # of observations to view. The helpText function is also used to 
  # include clarifying text. Most notably, the inclusion of a 
  # submitButton defers the rendering of output until the user 
  # explicitly clicks the button (rather than doing it immediately
  # when inputs change). This is useful if the computations required
  # to render output are inordinately time-consuming.
  sidebarPanel(

    selectInput("dataplot", "Choose a category:",
                choices = c("Points", "Rebounds", "Assists")),

    selectInput("dataset", "Choose a filter:", 
                choices = c("All games", "Wins", "Losses")),

    numericInput("obs", "Number of observations to view:", 10),

    helpText("Note: while the data view will show only the specified",
             "number of observations, the summary will still be based",
             "on the full dataset."),

    submitButton("Update View")
  ),

  # Show a summary of the dataset and an HTML table with the requested
  # number of observations. Note the use of the h4 function to provide
  # an additional header above each output section.
  mainPanel(

    h4("Reactive boxplot"),
    plotOutput("dynoplot"),

    h4("Hella boxplots"),
    plotOutput("boxplot"),

    h4("Summary"),
    verbatimTextOutput("summary"),

    h4("Observations"),
    tableOutput("view")
  )
))