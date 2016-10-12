class AddFirstDateToRepost < ActiveRecord::Migration[5.0]
  def change
    add_column :reposts, :first_date, :datetime
  end
end
