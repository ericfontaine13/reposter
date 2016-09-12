class AddEngagementToTwit < ActiveRecord::Migration[5.0]
  def change
    add_column :twits, :engagement, :integer
  end
end
