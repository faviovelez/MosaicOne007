class AddSentToDateAdvise < ActiveRecord::Migration
  def change
    add_column :date_advises, :sent, :boolean, default: false
  end
end
