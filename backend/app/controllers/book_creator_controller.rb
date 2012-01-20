class BookCreatorController < ApplicationController
  before_filter :authenticate_user!
  protect_from_forgery except: :save_image

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

    @templates = Template.order('created_at')#.all(:include => :user).delete_if {|t| not (t.user.nil? || t.user == current_user)}

    #Did the user select a template?
    unless params['template'].nil?
      @template = Template.find(params['template'])
    else
      @template = current_user.template
    end
   
    # Pick a random one...
    @template ||= @templates.first
  end

  def preview_text
    @image = current_user.image_url
    @thumb = current_user.thumb_url

    #Text templates
    text_size = 0
    text_size += current_user.template_title.size rescue 0
    text_size += current_user.template_text.size rescue 0
    text_size /= 10 #word count approximate
    puts "text_size is #{text_size}"
    @templates = TextTemplate.find :all, :conditions => ["? >= min_text and ? <= max_text", text_size, text_size]
    @templates = TextTemplate.all if @templates.empty?
  end

  def save_image
    begin
      current_user.update_image request.body.read
      render :json => true
    rescue
      render :json => false
    end
  end

  def save_text_template
    current_user.text_template_id = params['id']
    current_user.save

    redirect_to "/?user=#{current_user.id}"
  end
end
