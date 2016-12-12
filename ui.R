library(shiny)

shinyUI(fluidPage(theme="bootstrap.css",
  titlePanel(fluidRow(
    column(3, img(src="banner2.png", height=108, width=192)), 
    column(8, 
           h3("MA615 Twitter Data Mining Project"),
           h6("Presented by Ziyan Li (Mark), BU MSSP. 
              All the codes can be approached from", a(href="https://github.com/ziyanli/mining_twitter", "ziyanli Github")),
           h6("Visit",a(href="http://www.nba.com/rockets/","Houston Rockets Official Site"), "for more information.")))),
  navbarPage(title= "",
             tabPanel("Introduction",
                      img(src="pic0.png", height=700, width=1120),
                      hr(),
                      p("")),
             tabPanel("Pictures",
                      splitLayout(img(src="pic1.png", height=512, width=640),
                                  img(src="pic2.png", height=512, width=640)),
                      hr(),
                      p("All pictures are from", span("Houston Rockets official website", style="color:red"), 
                        "Click the link for more information!"), 
                      a(href="http://www.nba.com/rockets/","Houston Rockets official website"),
                      br()
                      ),
             tabPanel("Maps",
                      h4("Who are talking about Houston Rockets?"),
                      p("Limited by the Twitter's API (unable to search for tweets by key words and geo-location simultaneously) 
                        and Google's 2500 requests per day for geocode, these maps are not perfect. But still we can get a rough
                        idea about where people are talking about", span("Houston Rockets", style="color:red"), "through Twitter.
                        Without surprise, as shown in the maps, most of them are from Houston, TX."),
                      hr(),
                      fixedRow(
                        column(6, plotOutput("map1")),
                        column(6, plotOutput("map2"))
                      )
             ),
             tabPanel("Player Timeline",
                      h4("Track your favorite players on Twitter timeline."),
                      p("Here you can select your favorite player and track his favorites and retweets on Twitter. (note that
                        limited by the version of shinyapp, the", code("hoverinfo"), "in Plotly, which allows to show every tweet
                        that we are tracking, does not work here)"),
                      hr(),
                      sidebarLayout(
                        sidebarPanel(selectInput(inputId="player",
                                                 label="Select player",
                                                 choices=names(player.tweets)),
                                     actionButton(inputId="showtimeline",
                                                  label="Show Twitter Timeline")),
                        mainPanel(plotlyOutput("timeline"), textOutput("text1"))
                      )),
             
             tabPanel("Sentiment Analysis",
                      h4("Sentiment Analysis"),
                      p("With all the recent tweets can be captured for each player, I conducted a sentiment analysis
                        and visualize the sentiment flow. The word bank adopted here is", 
                        strong("NRC Word-Emotion Association Lexicon"), "(R package {syuzhet}). For simplicity, only positive
                        and negative measurement are shown here."),
                      hr(),
                      sidebarLayout(
                        mainPanel(plotlyOutput("sentiment"), textOutput("")),
                        sidebarPanel(selectInput(inputId="player1",
                                                 label="Select player",
                                                 choices=names(player.sentiment)),
                                     actionButton(inputId="sentiment",
                                                  label="Show Sentiment Flow"))
                      )),
             
             tabPanel("Word Cloud",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("word", "Choose a key word",
                                      choices = c("Houston Rockets", "James Harden")),
                          sliderInput("freq", "Minimum Frequency:",
                                      min = 1,  max = 50, value = 15),
                          sliderInput("max", "Maximum Number of Words:", 
                                      min = 1,  max = 300,  value = 100)),
                        mainPanel(
                          plotOutput("wordcloud")
                        )
                      )
                      )
             )
  
))






