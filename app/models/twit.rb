
class Twit < ApplicationRecord

  def self.get_tweets user
    all_tweets = TWITTER.user_timeline(user, count: "100", exclude_replies: true, include_rts: false)
    good_tweets = all_tweets.select{ |t| t.retweet_count + t.favorite_count > 4 &&
      Nokogiri::HTML.parse(t.source.gsub("\"", "")).text != "Repostr" }
    good_tweets.each do |tweet|
      Twit.find_or_create_by(link: "#{tweet.uri}") do |twit|
        twit.link = tweet.uri
        twit.content = tweet.text.gsub(/(https?):\/\/\w+.\w+\/?\w+/, "")
        twit.like = tweet.favorite_count
        twit.retweet = tweet.retweet_count
        twit.first_date = tweet.created_at
        twit.engagement = twit.like + twit.retweet
        if tweet.media[0].present?
          twit.image_url = tweet.media[0].media_url
        else
          twit.image_url = "/assets/bg-homepage.jpg"
        end
        if tweet.urls[0].present?
          twit.content_url = tweet.urls[0].expanded_url.to_s.split("?")[0]
        else
          twit.content_url = nil
        end
        if tweet.media[0].kind_of? Twitter::Media::Video
          videos = tweet.media[0].video_info[:variants]
          bitrate = videos.select{ |t| t.bitrate.present? }
          twit.video_url = bitrate[0].url
        else
          twit.video_url = nil
        end
      end
    end
  end

  def self.filter(type = nil, min = nil, max = nil, start_at = nil, end_at = nil, media = nil)
    a = Twit.all
    a = a.order("#{type}": :desc) if type.present?
    a = a.where(type => min..max) if min.present? && max.present?
    a = a.where(first_date: start_at..end_at) if start_at.present? && end_at.present?
    a = a.where.not("#{media}": nil) if media.present?
    a

  end

end
