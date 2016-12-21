class RenameSumEngagementToEngagementSum < ActiveRecord::Migration[5.0]
  def change
    rename_column :reposts, :sum_engagement, :engagement_sum
  end
end
