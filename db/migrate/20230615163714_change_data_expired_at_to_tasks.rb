class ChangeDataExpiredAtToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :expired_at, :datetime, precision: 6, null: false
  end
end
