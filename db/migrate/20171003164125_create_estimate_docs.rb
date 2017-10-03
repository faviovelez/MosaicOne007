class CreateEstimateDocs < ActiveRecord::Migration
  def change
    create_table :estimate_docs do |t|
      t.references :prospect, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
