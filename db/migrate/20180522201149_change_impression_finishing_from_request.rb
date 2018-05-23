class ChangeImpressionFinishingFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :impression_finishing, :string
    add_column :requests, :impression_finishing, :string, array: true, default: []
  end
end
