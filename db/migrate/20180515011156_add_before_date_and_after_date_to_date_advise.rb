class AddBeforeDateAndAfterDateToDateAdvise < ActiveRecord::Migration
  def change
    add_column :date_advises, :before_date, :date
    add_column :date_advises, :after_date, :date
    remove_column :date_advises, :days_before, :integer
  end
end
