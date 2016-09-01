class Twit < ApplicationRecord

  def self.get_tweets user
    all_tweets = CLIENT.user_timeline(user, count: "5", exclude_replies: true, include_rts: false)
    all_tweets.each do |tweet|
      Twit.create!(content: "#{tweet.text}", link: "#{tweet.uri}", like: "#{tweet.favorite_count}", retweet: "#{tweet.retweet_count}")
    end
  end

  def self.most_liked
    order(like: :desc)
  end

  def self.most_retweeted
    order(retweet: :desc)
  end

end
