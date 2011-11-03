class AddTemplateTitleToUser < ActiveRecord::Migration
  def change
    add_column :users, :template_title, :string
    add_column :users, :template_text_id, :integer, :default => 0
  end
end
