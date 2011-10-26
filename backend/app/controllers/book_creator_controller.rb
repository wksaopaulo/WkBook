class BookCreatorController < ApplicationController
  before_filter :authenticate_user!

  def index
    @templates = Template.all(:include => :user).delete_if {|t| t.user.nil?}
    if current_user.template_picture.url.nil?
      @images = (1..10).map {|i| "upload_placeholder#{i}.jpg"}
    else
      @images = [current_user.template_picture.home.url]
    end
  end

  def preview
    @template = Template.find(params['template'])
  end
end
