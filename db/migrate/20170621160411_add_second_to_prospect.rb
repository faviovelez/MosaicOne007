class AddSecondToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :second_last_name, :string
  end
end
