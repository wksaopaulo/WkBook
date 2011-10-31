class AddBookPageToUser < ActiveRecord::Migration
  def change
    add_column :users, :book_page, :string
  end
end
