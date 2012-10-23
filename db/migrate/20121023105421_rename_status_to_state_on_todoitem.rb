class RenameStatusToStateOnTodoitem < ActiveRecord::Migration
  rename_column :to_do_items, :status, :state
end
