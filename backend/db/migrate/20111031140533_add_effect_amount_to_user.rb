class AddEffectAmountToUser < ActiveRecord::Migration
  def change
    add_column :users, :effect_amount, :float, default: 0.5, null: false
    remove_column :templates, :effect_amount
  end
end
