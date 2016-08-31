class CreateTwits < ActiveRecord::Migration[5.0]
  def change
    create_table :twits do |t|
      t.string :content
      t.string :link
      t.integer :like
      t.integer :retweet

      t.timestamps
    end
  end
end
