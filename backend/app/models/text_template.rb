class TextTemplate < ActiveRecord::Base
  has_many :users

  mount_uploader :picture, TextTemplatePictureUploader
  validates_presence_of :min_text
  validates_presence_of :max_text
  validates_presence_of :picture
end
