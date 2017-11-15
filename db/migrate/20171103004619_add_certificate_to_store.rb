class AddCertificateToStore < ActiveRecord::Migration
  def change
    add_column :stores, :certificate, :string
    add_column :stores, :key, :string
    add_column :stores, :certificate_password, :string
    add_column :stores, :certificate_number, :string
    add_column :stores, :certificate_content, :text
    add_column :stores, :bill_last_folio, :integer
    add_column :stores, :credit_note_last_folio, :integer
    add_column :stores, :debit_note_last_folio, :integer
    add_column :stores, :return_last_folio, :integer
    add_column :stores, :pay_bill_last_folio, :integer
    add_column :stores, :advance_e_last_folio, :integer
    add_column :stores, :advance_i_last_folio, :integer
  end
end
