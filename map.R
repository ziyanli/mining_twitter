library(streamR)
load("my_oauth.Rdata")

filterStream("tweets_hr.json", 
             track=c("houston rockets"), 
             timeout=1200, oauth=my_oauth)
hr.tweets.df <- parseTweets("tweets_hr.json", simplify=TRUE)
saveRDS(hr.tweets.df, file="hr.tweets.df.rds")

library(ggmap)
geo.point <- na.omit(hr.tweets.df$location)
geo.point <- geocode(location.point, messaging = FALSE) # turn into lon and lat

source(func.toState) # code in a separate file

# filter out location ouside us
geo.point <- geo.point %>% filter(lon > states$range[1] & lon < states$range[2]) %>% filter(lat > states$range[3] & lat < states$range[4])
geo.state <- as.data.frame(table(toState(geo.point)))

# Add missing states
missing <- unique(map.data$region)[!(unique(map.data$region) %in% geo.state$Var1)]
geo.state <- data.frame(state=c(as.vector(geo.state$Var1), missing), Freq=c(geo.state$Freq, rep(0,length(missing))))

saveRDS(geo.point, file="geo.point.rds")
saveRDS(geo.state, file="geo.state.rds")

# state plot
map.data  <-  map_data("state")
ggplot(geo.state, aes(map_id = state)) + geom_map(aes(fill = Freq), map = map.data) + expand_limits(x = map.data$long, y = map.data$lat)+ 
  theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(), 
        panel.background = element_blank(), panel.border = element_blank(), panel.grid.major = element_blank(), plot.background = element_blank(),
        plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + scale_fill_continuous(low='grey', high='darkred')

# scatter plot
map.data  <-  map_data("state")  
ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.25) + 
  expand_limits(x = map.data$long, y = map.data$lat) + 
  theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(), 
        panel.background = element_blank(), panel.border = element_blank(), panel.grid.major = element_blank(), plot.background = element_blank(),
        plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + 
  geom_point(data = geo.point, aes(x = lon, y = lat), size = 10, alpha = 1/7, color = "darkred") 

