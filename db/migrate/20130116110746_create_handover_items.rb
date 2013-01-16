class CreateHandoverItems < ActiveRecord::Migration
  def change
    create_table :handover_items do |t|
      t.references :to_do_item
      t.references :patient_list_from
      t.references :patient_list_to

      t.timestamps
    end
    add_index :handover_items, :to_do_item_id
    add_index :handover_items, :patient_list_from_id
    add_index :handover_items, :patient_list_to_id
  end
end
