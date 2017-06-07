class CreateModifiedFields < ActiveRecord::Migration
  def change
    create_table :modified_fields do |t|
      t.string :field
      t.references :request, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
