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
    unless params['user'].nil?
      current_user.template_picture = params['user']['template_picture']
      current_user.template_text = params['user']['template_text']
      current_user.template_title = params['user']['template_title']
      current_user.save
    end

    @templates = Template.all(:include => :user).delete_if {|t| not (t.user.nil? || t.user == current_user)}

    #Did the user select a template?
    unless params['template'].nil?
      @template = Template.find(params['template'])
    else
      @template = current_user.template
    end
   
    # Pick a random one...
    @template ||= @templates.sample
  end

  def save_image
    
  end
end
