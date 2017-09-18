class AddCertificateToBill < ActiveRecord::Migration
  def change
    add_column :bills, :certificate, :string
  end
end
