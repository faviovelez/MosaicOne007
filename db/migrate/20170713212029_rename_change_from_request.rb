class RenameChangeFromRequest < ActiveRecord::Migration
  def change
    rename_column :requests, :changed, :sensitive_fields_changed
  end
end
