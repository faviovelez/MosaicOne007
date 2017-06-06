class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :document
      t.string :type
      t.references :request, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
