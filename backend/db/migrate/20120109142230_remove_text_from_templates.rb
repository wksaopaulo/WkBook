class RemoveTextFromTemplates < ActiveRecord::Migration
  def change
    remove_column :templates, :text
  end
end
