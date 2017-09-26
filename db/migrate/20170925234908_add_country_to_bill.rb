class AddCountryToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :country, index: true, foreign_key: true
  end
end
