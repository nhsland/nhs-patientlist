class DropHandoverTable < ActiveRecord::Migration
  def up
    drop_table :handovers
  end

  def down
    create_table "handovers", :force => true do |t|
      t.integer  "to_do_item_id"
      t.integer  "handover_list_id"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
    end

    add_index "handovers", ["handover_list_id"], :name => "index_handovers_on_handover_list_id"
    add_index "handovers", ["to_do_item_id"], :name => "index_handovers_on_to_do_item_id"
  end
end
