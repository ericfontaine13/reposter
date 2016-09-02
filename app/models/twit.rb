
class Twit < ApplicationRecord

def self.get_tweets user
    all_tweets = CLIENT.user_timeline(user, count: "20", exclude_replies: true, include_rts: false)
    all_tweets.each do |tweet|
      Twit.find_or_create_by(link: "#{tweet.uri}") do |twit|
        twit.content = tweet.text
        twit.like = tweet.favorite_count
        twit.retweet = tweet.retweet_count
        twit.first_date = tweet.created_at
      end
    end
  end

  def self.order_by(arg, arg2)
    order("#{arg}": :"#{arg2}")
  end

end
