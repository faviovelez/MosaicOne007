class AddReasonToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :reason, :text
  end
end
