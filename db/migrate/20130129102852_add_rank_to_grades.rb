class AddRankToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :rank, :integer
  end
end
