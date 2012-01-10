class Template < ActiveRecord::Base
  has_many :users

  mount_uploader :preview, TemplatePreviewUploader
  mount_uploader :effect_file, EffectFileUploader

  attr_accessor :template_picture, :template_text
end
