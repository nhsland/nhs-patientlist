class RemoveGradeId < ActiveRecord::Migration
  def change
    change_table :handovers do |t|
      t.remove :grade_id
    end
    change_table :users do |t|
      t.remove :grade_id
    end
  end
end
