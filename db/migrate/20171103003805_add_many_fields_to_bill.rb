class AddManyFieldsToBill < ActiveRecord::Migration
  def change
    add_column :bills, :sat_certificate_number, :string
    add_column :bills, :certificate_number, :string
    add_column :bills, :qr_string, :string
    add_column :bills, :original_chain, :text
    add_column :bills, :sat_stampl, :text
    add_column :bills, :digital_stamp, :text
    add_column :bills, :subtotal, :float
    add_column :bills, :total, :float
    add_reference :bills, :sat_zipcode, index: true, foreign_key: true
    add_column :bills, :date_signed, :datetime
    add_column :bills, :leyend, :string
  end
end
