class BookCreatorController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.template_picture.url.nil?
      @images = (1..10).map {|i| "upload_placeholder#{i}.jpg"}
    else
      @images = [current_user.template_picture_url(:small)]
    end
  end

  def preview
    current_user.template_picture = params['user']['template_picture'] unless params['user']['template_picture'].nil?
    current_user.template_text = params['user']['template_text'] unless params['user']['template_text'].empty?
    current_user.save

    @templates = Template.all(:include => :user).delete_if {|t| t.user.nil?}
    @template = Template.first; current_user.template || @templates.sample
  end
end
