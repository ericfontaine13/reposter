class Repost < ApplicationRecord

  def self.create_repost (twits)
    #checked_twits.each do |twits|
      twit = Twit.find_by_id(twits)
      Repost.find_or_create_by(link: twit.link) do |repost|
        repost.content = twit.content
        repost.like = twit.like
        repost.retweet = twit.retweet
        repost.engagement = twit.engagement
        repost.content_url = shortener (twit.content_url)
        repost.image_url = twit.image_url
        repost.first_date = twit.first_date
        repost.click = get_click (repost.content_url)
        TWITTER.update_with_media("#{repost.content}#{repost.content_url}", open("#{repost.image_url}"))
      end
    #end
  end

  def self.filter (type = nil, min = nil, max = nil, start_at = nil, end_at = nil)
    a = Repost.all
    a = a.order("#{type}": :desc) if type.present?
    a = a.where(type => min..max) if min.present? && max.present?
    a = a.where(first_date: start_at..end_at) if start_at.present? && end_at.present?
    a
  end

  def self.shortener (url)
    short = `curl -X POST -d "url=#{url}" http://localhost:9393/`
    JSON.load(short)
  end

  def self.get_click (url)
    shortcode = url.gsub("http://repo.st/", "")
    click = `curl -X GET http://localhost:9393/tracking/#{shortcode}`
    JSON.load(click)
  end

end
