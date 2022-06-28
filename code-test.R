
library(rtweet)

rtweet_app(bearer_token = "AAAAAAAAAAAAAAAAAAAAAJoCeAEAAAAANmFlceLX735jJwoT36njImGzf1M%3DGSaPe2CUAvX3Hr0nIArnkd2ZCiSIx8TiOjOBkVZe8zGup88qeh")
auth <- rtweet_app(bearer_token = "AAAAAAAAAAAAAAAAAAAAAJoCeAEAAAAANmFlceLX735jJwoT36njImGzf1M%3DGSaPe2CUAvX3Hr0nIArnkd2ZCiSIx8TiOjOBkVZe8zGup88qeh")

#
auth_save(auth, "academic_auth2")
auth_as('academic_auth2')

df <- search_tweets("#rstats")

boris2 <- get_timeline("BorisJohnson", n=3200, retryOnRateLimit=120, resultType = "recent")


load("~/R/tweet-collections-credentialsR.RData")
token <- create_token(
  app = app_name, #your app name
  consumer_key = app_key, #consumer key for your app, replace the text between quotes with your app's key 
  consumer_secret = app_secret)


leaders %>% group_by(screen_name) %>%
  count()




leaders_analysis %>% group_by(screen_name) %>%
  summarise_at(vars(c('retweet_count', 'favorite_count')), mean)

usa <- stream_tweets(
  lookup_coords("Liverpool"),
  timeout = 60
)



library(tidytext)
library(stringr)







tidy <- leaders_2021 %>% 
  unnest_tokens(hashtags, token = "tweets")






