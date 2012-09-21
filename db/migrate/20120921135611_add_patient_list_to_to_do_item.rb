class AddPatientListToToDoItem < ActiveRecord::Migration
  def change
    add_column :to_do_items, :patient_list_id, :integer
  end
end
