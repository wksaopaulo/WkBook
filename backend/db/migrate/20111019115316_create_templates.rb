class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.string :preview
      t.float :effect_amount

      t.timestamps
    end
  end
end
