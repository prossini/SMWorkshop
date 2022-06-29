## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(dplyr)

load("leaders270622.RData")

names(leaders_2021)
dim(leaders_2021)
leaders_2021$is_retweet








library(descr)
freq(leaders_2021$retweet_location)

leaders_2021$retweet_location[leaders_2021$retweet_location == "Leeds, England"] <- "Leeds"
leaders_2021$retweet_location[leaders_2021$retweet_location == "London, England"] <- "London"
leaders_2021$retweet_location[leaders_2021$retweet_location == "London "] <- "London"

leaders_2021$retweet_location[leaders_2021$retweet_location == "Manchester, UK"] <- "Manchester"


leaders_2021$retweet_location[leaders_2021$retweet_location == "Manchester, UK"] <- "Manchester"

leaders_2021$Party <- "Labour"

leaders_2021$Party[leaders_2021$screen_name == "BorisJohnson"] <- "Tory"
freq(leaders_2021$Party)

leaders_2021$Party[leaders_2021$screen_name == "Keir_Starmer"] <- "Labour"

# create new variables ####
leaders_2021$popular_tweets <-  "viral"
leaders_2021$popular_tweets[leaders_2021$favorite_count > 500 & leaders_2021$favorite_count < 1000] <- 'popular'
leaders_2021$popular_tweets[leaders_2021$favorite_count <= 500] <- 'less popular'

freq(leaders_2021$popular_tweets)
# create new variables based on conditions
leaders_2021$Party <- ifelse(leaders_2021$screen_name == "BorisJohnson", "Tory", "Labour")

# subset data based on conditions
unpopular <- subset(leaders_2021, favorite_count <= 500)

hashtag <- subset(leaders_2021, !is.na(hashtags))
hashtag1 <- filter(leaders_2021, !is.na(hashtags))
leaders_2021 %>% filter(!is.na(hashtags)) %>%
  group_by(screen_name) %>%
  count()



freq(leaders_2021$Party)

leaders_2021 %>% group_by(screen_name) %>%
  count()

leaders_2021 %>% group_by(screen_name) %>%
   summarise_at(vars(c('retweet_count', 'favorite_count')), .funs = c(avg = mean, std_dev = sd), na.rm=TRUE)

write.csv(x, "means_rt_fav.csv")


leaders %>%
  filter(date >= "2021-01-01") %>%
  group_by(screen_name) %>% 
  rtweet::ts_plot("week", trim = 2L) +
  theme_classic() + 
  scale_x_datetime(date_labels = "%b %d", breaks = "2 week") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  scale_color_brewer(type = "qual", palette = 6, direction = -1) +
  labs(x = "Weeks in 2021", y = "Number of Tweets per Week",title = 'Boris Johnson and Keir Starmer Tweet Activity 2021', caption = "Tweets collected using the Twitter API and rtweet") + scale_y_continuous(n.breaks = 10)


## Hashtags
## 

library(tidyverse)

leaders_hash <- select(leaders_2021, screen_name, hashtags, favorite_count, retweet_count)

hash <- leaders_hash %>% 
  group_by(screen_name) %>%
  mutate(hashtags = tolower(hashtags)) %>%
  unnest(c(hashtags)) %>%
  count(hashtags)

hash$hashtags <- tolower(hash$hashtags)

hash <- hash %>% 
  group_by(screen_name) %>%
  count(hashtags)


hash$hashtags <- tolower(hash$hashtags)

# top10 
top10 <- leaders_hash %>%
  group_by(screen_name) %>%
  unnest(c(hashtags)) %>%
  count(hashtags) %>%
  filter(!is.na(hashtags)) %>%  # get rid of the blank value
  slice_max(order_by = n, n = 10)



# plotting top 10 hashtags with a facet grid


top10 %>% ggplot(aes(x = hashtags, y = n, fill = screen_name)) +
  geom_bar(stat = "identity", position = "dodge") + coord_flip() + facet_grid(. ~ screen_name )


# filtering by words in a hashtag and assigning to a dataset 

x <- hash %>% filter(grepl('covid', hashtags)) 

# the same but with tweets,
# first, lower case
leaders_2021$text <- tolower(leaders_2021$text)
# then search for word in tex
y <- leaders_2021 %>% filter(grepl("london", text))
freq(y$screen_name)




# likes per hashtag
likes <- leaders_hash %>%
  group_by(screen_name) %>%
  unnest(c(hashtags)) %>%
  group_by(hashtags, screen_name) %>%
  summarise(total_likes = sum(favorite_count)) %>%
  ungroup()

# RTs by hashtag
RT <- leaders_hash %>%
  group_by(screen_name) %>%
  unnest(c(hashtags)) %>%
  group_by(hashtags, screen_name) %>%
  summarise(total_rts = sum(retweet_count)) %>%
  ungroup()


leaders_2021 %>%
  group_by(screen_name) %>%
  summarise(total_likes = sum(favorite_count)) %>%
  ungroup()

# visualize




## ----ggplot----------------------------------------------------------------------------------------------------------------------------------------------------
# basic plot of retweet vs tweets

leaders_2021 %>% 
  ggplot(aes(x=screen_name, fill = is_retweet)) +
  geom_bar(position = "stack")


## --------------------------------------------------------------------------------------------------------------------------------------------------------------

leaders_2021 %>% 
  ggplot(aes(x=screen_name, fill = is_retweet)) +
  geom_bar(position = "stack") + 
  labs(title = "Original Tweets and Retweets", caption = "Tweets from 01/01/2021 - 31/12/2021", x = "Is Retweet?", y = "N", fill = "Account") + theme_minimal()



## --------------------------------------------------------------------------------------------------------------------------------------------------------------
leaders_2021 %>% 
  group_by(screen_name, is_retweet) %>% 
  summarize(n = n()) %>% 
  mutate(perc = 100*n/sum(n)) 

# If you want to keep this table as a separate object, just assign it to an object (percentages_tab is an arbitrary name I picked): 

percentages <- leaders_2021 %>% 
  group_by(screen_name, is_retweet) %>% # we are using this to make sure the data is grouped to calculate proportions
  summarize(n = n()) %>% 
  mutate(perc = 100*n/sum(n)) 


## ----percentage plot, message=FALSE----------------------------------------------------------------------------------------------------------------------------
leaders_2021 %>% 
  group_by(screen_name, is_retweet) %>% 
  summarize(n = n()) %>% 
  mutate(perc = 100*n/sum(n)) %>%
  ggplot(aes(x= is_retweet, fill = screen_name, y = perc)) +
  geom_bar(position = "dodge",stat = "identity") + #we changed stat to identity because we  
  theme_minimal() + 
  labs(title = "Proportion of original Tweets and Retweets", caption = "Tweets from 01/01/2021 - 31/12/2021", x = "Is Retweet?", y = "%", fill = "Account") + theme_minimal() + 
  ylim(c(0, 100)) # this determines the limits of the y axis. 

ggplot(percentages, aes(x = screen_name, y = perc, fill = is_retweet)) + 
  geom_bar(stat = "identity", position = 'dodge')



## ----save plot, eval=FALSE, message=FALSE, inspect=FALSE-------------------------------------------------------------------------------------------------------
ggsave(
   filename,
   plot = last_plot(), dpi = 300)

