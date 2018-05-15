class AddPaymentToDateAdvise < ActiveRecord::Migration
  def change
    add_reference :date_advises, :payment, index: true, foreign_key: true
  end
end
