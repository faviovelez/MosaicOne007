class AddTranslationToRole < ActiveRecord::Migration
  def change
    add_column :roles, :translation, :string
  end
end
