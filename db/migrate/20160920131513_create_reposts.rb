class CreateReposts < ActiveRecord::Migration[5.0]
  def change
    create_table :reposts do |t|
      t.string :content
      t.string :link
      t.integer :like
      t.integer :retweet
      t.integer :engagement

      t.timestamps
    end
  end
end
