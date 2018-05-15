class AddDaysBeforeToDateAdvise < ActiveRecord::Migration
  def change
    add_column :date_advises, :days_before, :integer, default: 0
  end
end
