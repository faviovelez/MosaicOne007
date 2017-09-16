class CreateRelationTypes < ActiveRecord::Migration
  def change
    create_table :relation_types do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
