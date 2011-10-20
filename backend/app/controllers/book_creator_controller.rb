class BookCreatorController < ApplicationController
  before_filter :authenticate_user!

  def index
    @templates = Template.all(:include => :user).delete_if {|t| t.user.nil?}
  end

  def preview
    @template = Template.find(params['template'])
  end
end
