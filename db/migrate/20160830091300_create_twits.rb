class CreateTwits < ActiveRecord::Migration[5.0]
  def change
    create_table :twits do |t|
      t.string   "content"
      t.string   "link"
      t.integer  "like"
      t.integer  "retweet"
      t.integer  "engagement"
      t.string   "image_url"
      t.datetime "first_date"
      t.integer  "click"
      t.integer  "repost_id"
      t.timestamps
    end
  end
end
