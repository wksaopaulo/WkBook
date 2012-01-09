class AddTextTemplateIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :text_template_id, :integer
  end
end
