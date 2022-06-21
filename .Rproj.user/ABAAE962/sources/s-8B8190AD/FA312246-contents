
library(rtweet)

rtweet_app(bearer_token = "AAAAAAAAAAAAAAAAAAAAALLLdgEAAAAAbk101H0fzKVRV2AucxFmjSROSbc%3DgFTe0y4WKUA1s9wtofwuA01DdrQ54uChbUKYyTQ4mnNMxu43tD")
auth <- rtweet_app()
#
auth_save(auth, "academic_auth")
auth_as('academic_auth')

df <- search_tweets("#rstats")

boris <- get_timeline("BorisJohnson", n=3200, retryOnRateLimit=120, resultType = "recent")
