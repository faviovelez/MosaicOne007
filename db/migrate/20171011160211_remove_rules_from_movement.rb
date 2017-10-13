class RemoveRulesFromMovement < ActiveRecord::Migration
  def change
    remove_column :movements, :rule_applied, :boolean
    remove_column :movements, :reason, :string
  end
end
