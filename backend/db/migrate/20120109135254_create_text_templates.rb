class CreateTextTemplates < ActiveRecord::Migration
  def change
    create_table :text_templates do |t|
      t.string :picture
      t.integer :min_text
      t.integer :max_text

      t.timestamps
    end
  end
end
