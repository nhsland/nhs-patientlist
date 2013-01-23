class RemoveTeams < ActiveRecord::Migration
  def up
    drop_table :shifts
    drop_table :team_memberships
    drop_table :teams
  end

  def down
    create_table "shifts", :force => true do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "team_memberships", :force => true do |t|
      t.integer  "user_id"
      t.integer  "team_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "teams", :force => true do |t|
      t.string   "shift_id",   :null => false
      t.string   "name",       :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "teams", ["shift_id", "name"], :name => "index_teams_on_shift_id_and_name", :unique => true
    add_index "teams", ["shift_id"], :name => "index_teams_on_shift_id"
  end
end
