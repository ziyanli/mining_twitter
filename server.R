library(shiny)
library(ggplot2)
library(plotly)

shinyServer(function(input, output){

  output$outputcbg <- renderText(input$cbg)
  
  observeEvent(input$getplot,
  output$irisplot <- renderPlot(ggplot(data=iris) + geom_point(aes_string(x=input$selectx,y=input$selecty,color="Species")))
  )
  
  ### maps
  output$map1 <- renderPlot({
    map.data  <-  map_data("state")  
    ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.25) + 
      expand_limits(x = map.data$long, y = map.data$lat) + 
      theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(), 
            panel.background = element_blank(), panel.border = element_blank(), panel.grid.major = element_blank(), plot.background = element_blank(),
            plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + 
      geom_point(data = geo.point, aes(x = lon, y = lat), size = 10, alpha = 1/7, color = "darkred") 
  })
  
  output$map2 <- renderPlot({
    map.data  <-  map_data("state")
    ggplot(geo.state, aes(map_id = state)) + geom_map(aes(fill = Freq), map = map.data) + expand_limits(x = map.data$long, y = map.data$lat)+ 
      theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(), 
            panel.background = element_blank(), panel.border = element_blank(), panel.grid.major = element_blank(), plot.background = element_blank(),
            plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + scale_fill_continuous(low='grey', high='darkred')
  })

  ### timeline
  observeEvent(input$showtimeline,{
    output$timeline <- renderPlotly({
      df <- as.data.frame(player.tweets[input$player])
      df <- df[, c(1,3,5,12)]
      names(df) <- c("text","favoriteCount","created","retweetCount")
      plot_ly(df, x = ~created, y = ~favoriteCount, name="Favorite", type = 'scatter',mode = 'lines', line=list(color="red")) %>% add_trace(
        y=~retweetCount, name="Retweet", type = 'scatter', mode = 'lines', line=list(color="darkred")) %>% layout(
          title = 'Favorites/Retweets of Player Twitter Account', xaxis = list(title = 'Date'), yaxis=list(title='Number of favorites/retweets'))})
    })
  # text output
  output$text1 <- renderText({ 
    paste("What happened to", input$player, "on Twiiter?")
  })
  
  ### sentiment
  observeEvent(input$sentiment,{
    output$sentiment <- renderPlotly({
      df1 <- as.data.frame(player.sentiment[input$player1])
      date <- as.data.frame(player.tweets[input$player1])
      df1 <- df1[, c(9,10)]
      date <- date[,5]
      df1 <- data.frame(df1, date)
      names(df1) <- c("negative","positive","created")
      plot_ly(df1, x = ~created, y = ~positive, name="Positive", type = 'scatter',mode = 'lines', line=list(color="red")) %>% add_trace(
        y=~-negative, name="Negative", type = 'scatter', mode = 'lines', line=list(color="green")) %>% layout(
          title = 'Player Positive/Negative Sentiment on Twitter', xaxis = list(title = 'Date'), yaxis=list(title='Sentiment Measurement'))})
  })
  
  ### wordcloud
  output$wordcloud <- renderPlot({
    if (input$word=='Houston Rockets') {
      wordcloud(words = wordCorpus1, scale=c(5,0.2), min.freq = input$freq, max.words=input$max,
                random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(9,"Reds")[5:9])
    }
    else {
      wordcloud(words = wordCorpus2, scale=c(5,0.2), min.freq = input$freq, max.words=input$max,
                random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(9,"Reds")[4:8])
    }
  })

  })