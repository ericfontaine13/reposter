class Twit < ApplicationRecord

  def self.most_liked()
    order(like: :desc)
  end

  def self.most_retweeted
    order(retweet: :desc)
  end

end
