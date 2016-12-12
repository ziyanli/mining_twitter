######Sentiment Analysis
##########################
library(tm)
library(syuzhet)

player.tweets <- readRDS('player.tweets.rds')

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
