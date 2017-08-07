class AddMailToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :email, :string
  end
end
