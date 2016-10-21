desc 'get tweets from a specicic twitter user'
task get_tweets: :environment do
  Twit.get_tweets("opencoconut")
end
