
library(rtweet)
load("~/R/tweet-collections-credentialsR.RData")
token <- create_token(
   app = app_name, #your app name
   consumer_key = app_key, #consumer key for your app, replace the text between quotes with your app's key
   consumer_secret = app_secret)
##
##
load("leaders_tweets270622.RData")

options(scipen=999, digits = 4)
library(tidyverse)
library(lubridate)
library(glue)
library(descr)
library(stringr)
##

## getting tweets from one user and assigning them to an object named 'Boris'
boris <- get_timeline("BorisJohnson", n=3200, retryOnRateLimit=120, resultType = "recent")


## getting tweets from several users and assigning them to a single object named 'leaders'
leaders <- get_timeline(c("BorisJohnson", "Keir_Starmer", "Conservatives", "UKLabour") , n=3200, retryOnRateLimit=120, resultType = "recent", parse = TRUE)

## if we want to save this data to work on it later, just use the following command:
save(leaders, file = "leaders_tweets270622.RData") # to save it as an R object
write_as_csv(leaders, file_name = "leaders_tweets270622.csv") # to save as a CSV that can be opened in excel. This function is from the package rtweet, not the same as 'write.csv' from base R.

## colnames(leaders)

## head(leaders)
## 
##
## freq(leaders$screen_name) # freq is a function of the package descr. Unsurprisingly, we have about 3200 for all accounts, as this is the maximum we can retrieve using the free API
##
## # we can use dplyr to do the same:
##
leaders %>% group_by(screen_name) %>%
   count()

## #let's check the dates.
## #First we convert the date column to a 'date' object using the function as.Date:
## leaders$created_at <- as.Date(leaders$created_at)
##
## #then, we check the earliest and latest tweet date per account:
## leaders %>% group_by(screen_name) %>% summarise(min(created_at), max(created_at))
##
## # from this we notice that tweets by Boris Johnson go way back to July, 2019, but all others were some time in 2020.
## # To make our dataset comparable, let's limit the analysis to tweets posted in 2022, filtering by date.
## # I will assign the filtered dataset to a new object just in case we want to return to the full set some other time.
##
## leaders_analysis <- leaders %>% filter(created_at >= '2022-01-01') #now our new data has 7040 tweets. Let's check again the dates to make sure it looks correct:
## leaders_analysis %>% group_by(screen_name) %>% summarise(min(created_at), max(created_at)) # great, now all our accounts have tweets for the same period of time!
##

##
##
## leaders_analysis %>% group_by(screen_name) %>%
##   summarise_at(vars(c('retweet_count', 'favorite_count', 'reply_count')), mean, na.rm=T)

## hasthag <- search_tweets(
##   "##sundayvibes",include_rts = FALSE, retryonratelimit = TRUE) # here we are asking the API for tweets using this hashtag, excluding RTs
##
## # search terms using search operators (AND, OR)
##
## rt <- search_tweets(q = "rstats AND python")
##

##
## # people I follow
## i_fw <- get_friends("patyrossini")
## # people following me
## my_fw <- get_followers("patyrossini")
##

##
## # stream tweets based on search (can use advance operator)
## st <- stream_tweets(q = "weather", timeout = 30)
##
## # stream random sample
## sr <- stream_tweets(q = "", timeout = 30)
##
