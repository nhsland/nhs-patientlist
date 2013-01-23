class AddGradeToToDoItem < ActiveRecord::Migration
  def change
    add_column :to_do_items, :grade_id, :integer
  end
end
