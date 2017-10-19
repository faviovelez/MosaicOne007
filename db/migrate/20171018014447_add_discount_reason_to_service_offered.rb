class AddDiscountReasonToServiceOffered < ActiveRecord::Migration
  def change
    add_column :service_offereds, :discount_reason, :string
  end
end
