class CreateFiscalResidencies < ActiveRecord::Migration
  def change
    create_table :fiscal_residencies do |t|

      t.timestamps null: false
    end
  end
end
