class AddClickToRepost < ActiveRecord::Migration[5.0]
  def change
    add_column :reposts, :click, :integer
  end
end
