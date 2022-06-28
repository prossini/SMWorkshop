## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)

load("leaders270622.RData")



## ----means, include=TRUE, eval=FALSE, inspect=FALSE------------------------------------------------------------------------------------------------------------
## load("leaders270622.RData")
## 
## leaders_2021 %>% group_by(screen_name) %>%
##   summarise_at(vars(c('retweet_count', 'favorite_count')), .funs = c(mean = mean), na.rm=TRUE)
## 
## 


## ---- include=TRUE---------------------------------------------------------------------------------------------------------------------------------------------

leaders_2021 %>%
  group_by(screen_name) %>% 
  rtweet::ts_plot("weeks", trim = 2L) +
  geom_abline() +
  theme_classic() +
  scale_x_datetime(date_labels = "%b %d", breaks = "2 week") +
  scale_color_brewer(type = "qual", palette = 2) +
  ggplot2::theme(
    legend.title = ggplot2::element_blank(),
    legend.position = "bottom",
    plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "@BorisJohnson & @Keir_Starmer on Twitter, 2021",
    subtitle = "Aggregated by 2 weeks")  + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


## ----ggplot----------------------------------------------------------------------------------------------------------------------------------------------------
# basic plot of retweet vs tweets

leaders_2021 %>% 
  ggplot(aes(x=is_retweet, fill = screen_name)) +
  geom_bar(position = "dodge")


## --------------------------------------------------------------------------------------------------------------------------------------------------------------

leaders_2021 %>% 
  ggplot(aes(x=is_retweet, fill = screen_name)) +
  geom_bar(position = "dodge") + 
  labs(title = "Original Tweets and Retweets", caption = "Tweets from 01/01/2021 - 31/12/2021", x = "Is Retweet?", y = "N", fill = "Account") + theme_minimal()



## --------------------------------------------------------------------------------------------------------------------------------------------------------------
leaders_2021 %>% 
  group_by(screen_name, is_retweet) %>% # we are using this to make sure the data is grouped to calculate proportions
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




## ----save plot, eval=FALSE, message=FALSE, inspect=FALSE-------------------------------------------------------------------------------------------------------
ggsave(
   filename,
   plot = last_plot(), dpi = 300)

