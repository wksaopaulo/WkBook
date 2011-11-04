class AddTextIdToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :text_id, :integer, :nil => true, :default => nil
  end
end
