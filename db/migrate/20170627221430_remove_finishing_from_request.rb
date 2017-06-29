class RemoveFinishingFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :which_finishing, :string
  end
end
