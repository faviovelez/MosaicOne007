class AddCellToStore < ActiveRecord::Migration
  def change
    add_column :stores, :cell_phone, :string
    remove_column :stores, :cellphone, :string
  end
end
