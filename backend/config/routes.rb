Wkbook::Application.routes.draw do
  

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :book_admins

  devise_for :users

  match 'book_creator' => 'book_creator#index'
  match 'book_creator/preview' => 'book_creator#preview'
  match 'book_creator/preview_text' => 'book_creator#preview_text'
  match 'book_creator/save_image' => 'book_creator#save_image'
  match 'book_creator/save_text_template' => 'book_creator#save_text_template'

  root :to => 'home#index'

end
