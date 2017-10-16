class AddCfdiUseToTicket < ActiveRecord::Migration
  def change
    add_reference :tickets, :cfdi_use, index: true, foreign_key: true
  end
end
