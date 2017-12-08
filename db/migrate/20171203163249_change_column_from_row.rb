class ChangeColumnFromRow < ActiveRecord::Migration
  def change
    change_column :rows, :description, :text
  end
end
