class CreateDesignRequests < ActiveRecord::Migration
  def change
    create_table :design_requests do |t|
      t.string :design_type
      t.float :cost
      t.string :status
      t.boolean :authorisation
      t.string :attachment
      t.string :outcome

      t.timestamps null: false
    end
  end
end
