class TextTemplate < ActiveRecord::Base
  has_many :users

  mount_uploader :picture, TextTemplatePictureUploader
  validates_presence_of :min_text
  validates_presence_of :max_text
  validates_presence_of :picture

  def image_area
    val = self.rect || "0, 0, 100 ,100"
    eval "[#{val}]"
  end
end
