class AddCfdiUseToPreferredBillOptions < ActiveRecord::Migration
  def change
    add_reference :preferred_bill_options, :cfdi_use, index: true, foreign_key: true
  end
end
