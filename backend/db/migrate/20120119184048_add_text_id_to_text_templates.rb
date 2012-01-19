class AddTextIdToTextTemplates < ActiveRecord::Migration
  def change
    add_column :text_templates, :text_id, :integer
    remove_column :text_templates, :min_chars, :integer
    remove_column :text_templates, :max_chars, :integer
  end
end
