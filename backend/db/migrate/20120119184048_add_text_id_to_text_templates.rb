class AddTextIdToTextTemplates < ActiveRecord::Migration
  def change
    add_column :text_templates, :text_id, :integer
    remove_column :text_templates, :min_text, :integer
    remove_column :text_templates, :max_text, :integer
  end
end
