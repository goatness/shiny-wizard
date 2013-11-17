library(shiny)
library(ggplot2)

wall <- read.table("JWAggregatedv3.csv", header = TRUE, sep = ",")
#beal <- read.table("BradBeal20122013RegSeasonMajorStats.csv", header = TRUE, sep = ",")

as.data.frame(wall)

#Select relevant variables
wall.clean <- subset(wall, select = c(Opponent, WL, FGA, FG_Percent, X3PA, X3P_Percent, FTA, FT_Percent, TRB, AST, STL, BLK, TO, PTS, PF) )


#Subset of Wins

wall.win <- subset(wall.clean, WL == 'W')
as.data.frame(wall.win)

#Subset of Losses

wall.loss <- subset(wall.clean, WL == 'L')
as.data.frame(wall.loss)

#Subset for box plot:
wall.box <- subset(wall.clean, select = c(FG_Percent, X3P_Percent, FT_Percent, TRB, AST, STL, BLK, TO, PTS))


#create boxplots
p <- ggplot(wall.clean, aes(factor(WL), PTS)) + geom_boxplot(aes(fill=factor(WL)), notch=TRUE, outlier.colour = "red") + geom_jitter()
r <- ggplot(wall.clean, aes(factor(WL), TRB)) + geom_boxplot(aes(fill=factor(WL)), notch=TRUE, outlier.colour = "red") + geom_jitter()
a <- ggplot(wall.clean, aes(factor(WL), AST)) + geom_boxplot(aes(fill=factor(WL)), notch=TRUE, outlier.colour = "red") + geom_jitter()


# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {

  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "All games" = wall.clean,
           "Wins" = wall.win,
           "Losses" = wall.loss
           #input$beal,
           #"Bradley Beal" = beal
           )
  })


  # Return requested boxplot

  datasetInput <- reactive({
    switch(input$dataplot,
          "Points" = p,
          "Rebounds" = r,
          "Assists" = a
          )
    })
  # Generate a static boxplot of dataset

  output$boxplot <- renderPlot(function() {
    p <- ggplot(wall.clean, aes(factor(WL), PTS)) + geom_boxplot(aes(fill=factor(WL)), notch=TRUE, outlier.colour = "red") + geom_jitter()
    print(p)
    })

  #Generate boxplots being requested

  output$dynoplot <- renderPlot(function() {
    dataplot <- datasetInput()
  }) 

  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })

  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})