class User < ActiveRecord::Base
  # Image uploaded by user
  mount_uploader :template_picture, BookImageUploader

  belongs_to :template

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
  def image_url
    "/pages/#{self.id}.png"
  end

  def update_image img
    File.open(self.image_path, "wb") {|f| f.puts img }
  end

end
