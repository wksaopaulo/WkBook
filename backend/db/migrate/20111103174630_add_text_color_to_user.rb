class AddTextColorToUser < ActiveRecord::Migration
  def change
    add_column :users, :template_text_color, :integer
  end
end
