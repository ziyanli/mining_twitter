library(devtools)
library(twitteR)
library(tm)
library(stringr)
library(wordcloud)

api_key <- 	"u3gtfzOt06ZWpfmCrAkmspY1y"
api_secret <- "JX0DM2jYciVuzZG0SipT69PiU7Dg7n71E7e8qnbeQaUpLsXNPc"
access_token <- "793886995550441472-uhG1CxqFAs6GT22rTS9JfMCs3TGon5P"
access_token_secret <- "iOc3Wfwe1GpMeEIvj82lWp6FUPeB7DVyaHZwIMkFy9uiq"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

### houston rockets
HoustonRockets <- searchTwitteR("", lang="en", n=5000)
HoustonRockets <- twListToDF(HoustonRockets)
# str_replace_all(HoustonRockets$text, "@", "")
wordCorpus <- Corpus(VectorSource(str_replace_all(HoustonRockets$text, "@", "")))
wordCorpus <- tm_map(wordCorpus, removePunctuation)
wordCorpus <- tm_map(wordCorpus, content_transformer(tolower))
wordCorpus <- tm_map(wordCorpus, removeWords, stopwords("english"))
wordCorpus <- tm_map(wordCorpus, removeWords, c("houston","rockets"))
wordCorpus <- tm_map(wordCorpus, stripWhitespace)
saveRDS(HoustonRockets, file="HoustonRockets.rds")

pal <- brewer.pal(9,"Reds")
pal <- pal[-(1:4)]
set.seed(123)
wordcloud(words = wordCorpus, scale=c(5,0.2), max.words=500, random.order=FALSE, 
          rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(9,"Reds")[5:9])

### clutch city ? bad results.
ClutchCity <- searchTwitteR("clutchcity", lang="en", n=5000)
ClutchCity <- twListToDF(ClutchCity)
wordCorpus <- Corpus(VectorSource(str_replace_all(ClutchCity$text, "@", "")))
wordCorpus <- tm_map(wordCorpus, removePunctuation)
wordCorpus <- tm_map(wordCorpus, content_transformer(tolower))
wordCorpus <- tm_map(wordCorpus, removeWords, stopwords("english"))
wordCorpus <- tm_map(wordCorpus, removeWords, c("clutchcity"))
wordCorpus <- tm_map(wordCorpus, stripWhitespace)
saveRDS(ClutchCity, file="ClutchCity.rds")

### james harden
JH <- searchTwitteR("James Harden", lang="en", n=5000)
JH <- twListToDF(JH)
wordCorpus <- Corpus(VectorSource(str_replace_all(JH$text, "@", "")))
wordCorpus <- tm_map(wordCorpus, removePunctuation)
wordCorpus <- tm_map(wordCorpus, content_transformer(tolower))
wordCorpus <- tm_map(wordCorpus, removeWords, stopwords("english"))
wordCorpus <- tm_map(wordCorpus, removeWords, c("james", "harden"))
wordCorpus <- tm_map(wordCorpus, stripWhitespace)
saveRDS(JH, file="JH.rds")
