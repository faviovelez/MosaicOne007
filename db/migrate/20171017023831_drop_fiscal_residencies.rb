class DropFiscalResidencies < ActiveRecord::Migration
  def change
    drop_table :fiscal_residencies
  end
end
