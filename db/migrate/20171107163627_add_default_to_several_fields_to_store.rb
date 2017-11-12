class AddDefaultToSeveralFieldsToStore < ActiveRecord::Migration
  def change
    change_column :stores, :bill_last_folio, :integer, default: 0
    change_column :stores, :credit_note_last_folio, :integer, default: 0
    change_column :stores, :debit_note_last_folio, :integer, default: 0
    change_column :stores, :return_last_folio, :integer, default: 0
    change_column :stores, :pay_bill_last_folio, :integer, default: 0
    change_column :stores, :advance_e_last_folio, :integer, default: 0
    change_column :stores, :advance_i_last_folio, :integer, default: 0
  end
end
