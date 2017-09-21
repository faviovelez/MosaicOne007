class CreateFinishings < ActiveRecord::Migration
  def change
    create_table :finishings do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
