class ChangeColumnNullTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :title, :string, null: false
  end
end
