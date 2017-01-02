class AddRepostIdToRecurrence < ActiveRecord::Migration[5.0]
  def change
    add_column :recurrences, :repost_id, :integer
  end
end
