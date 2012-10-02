class AddRiskLevelToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :risk_level, :string, :default => "low"
  end
end
