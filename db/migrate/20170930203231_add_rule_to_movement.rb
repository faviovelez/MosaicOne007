class AddRuleToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :rule_could_be, :boolean, default: false
    add_column :movements, :rule_applied, :boolean, default: false
  end
end
