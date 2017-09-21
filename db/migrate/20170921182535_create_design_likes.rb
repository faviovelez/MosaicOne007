class CreateDesignLikes < ActiveRecord::Migration
  def change
    create_table :design_likes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
