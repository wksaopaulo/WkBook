class Template < ActiveRecord::Base
  has_many :users

  mount_uploader :preview, TemplatePreviewUploader
end
