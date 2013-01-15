class DropHandoverListTable < ActiveRecord::Migration
  def up
    drop_table :handover_lists
  end

  def down
    create_table "handover_lists", :force => true do |t|
      t.date     "shift_date"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer  "team_id"
    end
  end
end
