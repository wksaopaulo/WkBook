class RemoveUnusedFields < ActiveRecord::Migration
  def change
    remove_column :users, :template_text_id
    remove_column :users, :template_text_color
  end
end
