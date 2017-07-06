class FixSomethingFromRequest < ActiveRecord::Migration
  def change
    rename_column :requests, :authorisation, :authorised_without_doc
    rename_column :requests, :authorised, :authorised_without_pay
  end
end
