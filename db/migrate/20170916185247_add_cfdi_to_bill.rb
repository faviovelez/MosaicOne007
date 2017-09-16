class AddCfdiToBill < ActiveRecord::Migration
  def change
    add_column :bills, :sequence, :string
    add_column :bills, :folio, :string
    add_reference :bills, :expedition_zip, index: true, foreign_key: true
    add_reference :bills, :payment_condition, index: true, foreign_key: true
    add_reference :bills, :payment_method, index: true, foreign_key: true
    add_reference :bills, :payment_form, index: true, foreign_key: true
    add_reference :bills, :tax_regime, index: true, foreign_key: true
    add_reference :bills, :cfdi_use, index: true, foreign_key: true
    add_reference :bills, :tax, index: true, foreign_key: true
    add_reference :bills, :pac, index: true, foreign_key: true
    add_column :bills, :fiscal_folio, :string
    add_column :bills, :digital_stamp, :string
    add_column :bills, :sat_stamp, :string
    add_column :bills, :original_chain, :string
    add_reference :bills, :relation_type, index: true, foreign_key: true
    add_reference :bills, :child_bills, index: true
    add_reference :bills, :parent, index: true
  end
end
