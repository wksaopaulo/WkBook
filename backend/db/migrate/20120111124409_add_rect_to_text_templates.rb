class AddRectToTextTemplates < ActiveRecord::Migration
  def change
    add_column :text_templates, :rect, :string, :default => nil
  end
end
