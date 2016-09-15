
class Twit < ApplicationRecord

  def self.get_tweets user
    all_tweets = CLIENT.user_timeline(user, count: "20", exclude_replies: true, include_rts: false)
    all_tweets.each do |tweet|
      Twit.find_or_create_by(link: "#{tweet.uri}") do |twit|
        twit.content = tweet.text
        twit.like = tweet.favorite_count
        twit.retweet = tweet.retweet_count
        twit.first_date = tweet.created_at
        twit.engagement = twit.like + twit.retweet
      end
    end
  end

  def self.filter(type = nil, min = nil, max = nil, start_at = nil, end_at = nil)
    a = Twit.all
    a = a.order("#{type}": :desc) if type.present?
    a = a.where(type => min..max) if min.present? && max.present?
    a = a.where(first_date: start_at..end_at) if start_at.present? && end_at.present?
    a
  end

end
