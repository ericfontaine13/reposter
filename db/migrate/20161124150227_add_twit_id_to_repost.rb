class AddTwitIdToRepost < ActiveRecord::Migration[5.0]
  def change
    add_column :reposts, :twit_id, :integer
  end
end
