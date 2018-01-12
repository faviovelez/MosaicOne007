class AddMoreEMailsToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :email_2, :string
    add_column :prospects, :email_3, :string
  end
end
