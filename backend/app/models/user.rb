class User < ActiveRecord::Base
  # Image uploaded by user
  mount_uploader :template_picture, BookImageUploader

  belongs_to :template
  belongs_to :text_template
  

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def has_page?
    File.exists? self.image_path
  end

  def image_path
    File.join(Rails.root, "public", "pages", "#{self.id}.png")
  end
  def thumb_path
    File.join(Rails.root, "public", "pages", "thumb_#{self.id}.png")
  end
  def high_res_image_path
    File.join(Rails.root, "public", "pages", "high_#{self.id}.png")
  end

  def image_url
    "/pages/#{self.id}.png"
  end
  def thumb_url
    "/pages/thumb_#{self.id}.png"
  end

  def update_image img

    File.open(self.high_res_image_path, "wb") {|f| f.puts img }

    require 'RMagick'
    img = Magick::Image::read(self.high_res_image_path).first
    img.resize_to_fit! 1000, 1000
    img.write(self.image_path) { self.quality = 80 }
    img.resize_to_fit! 200, 200
    img.write(self.image_path.gsub("pages/", "pages/thumb_")) { self.quality = 80 }

  end

end
