class RemoveImpressionFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :impression_type, :string
  end
end
