class AddSomethingToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :currency, index: true, foreign_key: true
    add_reference :bills, :fiscal_residency, index: true, foreign_key: true
    add_column :bills, :id_trib_reg_num, :string
    add_column :bills, :confirmation_key, :string
    add_column :bills, :exchange_rate, :float
  end
end
