
library(devtools)
library(twitteR)
library(plotly)

api_key <- 	"u3gtfzOt06ZWpfmCrAkmspY1y"
api_secret <- "JX0DM2jYciVuzZG0SipT69PiU7Dg7n71E7e8qnbeQaUpLsXNPc"
access_token <- "793886995550441472-uhG1CxqFAs6GT22rTS9JfMCs3TGon5P"
access_token_secret <- "iOc3Wfwe1GpMeEIvj82lWp6FUPeB7DVyaHZwIMkFy9uiq"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

### player's twitter account
twitter_acc <- data.frame(player=c("TrevorAriza", "PatrickBeverley", "MontrezlHarrel", "TylerEnnis", "SamDekker",
                                   "EricGordon", "JamesHarden", "ClintCapela", "KJMcDaniels", "CoreyBrewer"),
                          twitter=c("TrevorAriza", "patbev21", "MONSTATREZZ", "tdot_ennis", "dekker",
                                    "TheofficialEG10", "JHarden13", "CapelaClint", "KJMcDaniels", "TheCoreyBrewer"))
### search tweets for each player
apply(twitter_acc, 1, FUN = function(x) {
          df = userTimeline(x[2], n=3200)
          df = twListToDF(df)
          assign(x[1], df, envir=.GlobalEnv)})

### store them in a list and saveRDS
player.tweets <- list(TrevorAriza=TrevorAriza, PatrickBeverley=PatrickBeverley, MontrezlHarrel=MontrezlHarrel,
                      TylerEnnis=TylerEnnis, SamDekker=SamDekker, EricGordon=EricGordon, JamesHarden=JamesHarden,
                      ClintCapela=ClintCapela, KJMcDaniels=KJMcDaniels, CoreyBrewer=CoreyBrewer)
saveRDS(player.tweets, file='player.tweets.rds')

### example for making a plot
jh <- as.data.frame(player.tweets$JamesHarden)
p1 <- plot_ly(jh, x = ~created, y = ~favoriteCount, name="Favorite", type = 'scatter',
              mode = 'lines', line=list(color="red")) %>% add_trace(y=~retweetCount, name="Retweet", type = 'scatter', mode = 'lines', line=list(color="darkred")) %>% add_trace(
                y=max(jh$favoriteCount, jh$retweetCount), type = 'scatter', mode = 'lines', line=list(color="white"), hoverinfo = "text", text = ~text) %>% layout(
                  title = 'Favorites/Retweets of Spotify Twitter Account in the Past 3 Month', xaxis = list(title = 'Date'), 
                  yaxis=list(title='Number of favorites/retweets'))

######Sentiment Analysis
##########################
library(tm)
library(syuzhet)

### write a function to help to clean the text
clean.text <- function(some_txt){
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
  some_txt = gsub("@\\w+", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  some_txt = gsub("http\\w+", "", some_txt)
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  some_txt = gsub("amp", "", some_txt)
  # define "tolower error handling" function
  try.tolower = function(x)
  {
    y = NA
    try_error = tryCatch(tolower(x), error=function(e) e)
    if (!inherits(try_error, "error"))
      y = tolower(x)
    return(y)
  }
  some_txt = sapply(some_txt, try.tolower)
  names(some_txt) = NULL
  return(some_txt)
}

### iteration for each player, similar to timeline
player.text <- lapply(player.tweets, FUN=function(x) {clean.text(x$text)})
player.sentiment <- lapply(player.text, FUN=function(x) {get_nrc_sentiment(x)})
saveRDS(player.sentiment, file='player.sentiment.rds')



