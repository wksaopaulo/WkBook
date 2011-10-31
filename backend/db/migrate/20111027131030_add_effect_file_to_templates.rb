class AddEffectFileToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :effect_file, :string
  end
end
