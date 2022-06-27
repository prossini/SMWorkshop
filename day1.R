# Social Media workshop Leeds 28/6
options(scipen=999, digits = 4)

library(tidyverse)
library(lubridate)
library(descr)
library(stringr)
library(rtweet)

# authentication ####
create_token(app = "tweet-collections-R",
             consumer_key = "vCNeg272fEMh1MY2iw9AQKUq2",
             consumer_secret ="OvgFaiuK5WuI6FBbILQUOD4LBHnOZPLpWCYgKt6nB9efy2jdwf")

# get timelines ####
# 

boris <- get_timeline("BorisJohnson", n = 3200)

names(boris)
freq(boris$is_retweet)

boris %>% group_by(is_retweet) %>% 
  count()


leaders <- get_timeline(c("BorisJohnson", "Keir_Starmer"), n = 3200)

# save data ####
save(leaders, file = "leaders270622.RData")
write_as_csv(leaders, file_name = "leaders270622.csv")


leaders %>% 
  group_by(screen_name, is_retweet) %>% 
  summarise(n = n()) %>%
  mutate(freq = 100*(n / sum(n)))

crosstab(leaders$is_retweet, leaders$screen_name)

# here's how to do multiple searches for data collections ####

hashtag <- search_tweets(q = "#wimbledon", include_rts = FALSE, n = 2000)

search <- search_tweets(q = "weather", include_rts = FALSE, n = 2000)

search <- search_tweets(q = "weather OR sun", include_rts = FALSE, n = 2000)

stream <- stream_tweets(q = "#wimbledon", timeout = 30)

myfriends <- get_friends("patyrossini")

myfolowers <- get_followers("patyrossini")

hashtag2 <- search_tweets(q = "#rstats", include_rts = FALSE, n = 2000)



# some descriptive analyses #### 
load('leaders270622.RData')

names(leaders)


leaders %>% group_by(screen_name) %>% 
  count()


leaders$date <- as.Date(leaders$created_at)

leaders %>% group_by(screen_name) %>% summarise(min(created_at), max(created_at))

leaders_2021 <- leaders %>% filter(date >= "2021-01-01")
leaders_2021 <- leaders %>% filter(date >= "2021-01-01" & date < "2022-01-01")

leaders_2021 %>% group_by(screen_name) %>% summarise(min(created_at), max(created_at))
leaders_2021 %>% group_by(screen_name) %>% count()

save(leaders, leaders_2021, file = "leaders270622.RData")
load("leaders270622.RData")
