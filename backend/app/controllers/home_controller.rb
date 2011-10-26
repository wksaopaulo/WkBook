class HomeController < ApplicationController
  def index
    @user = User.all(order: 'name')
  end
end
