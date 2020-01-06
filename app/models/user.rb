class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  before_save :ensure_authentication_token
  mount_uploader :image, UserUploader
  enum role: [:normal, :trader, :admin]
  has_many :posts
  after_initialize :set_default_role, if: :new_record?
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
  def regenerate_password
     r = [ ]
    while r.length < 6
      v = rand(7)
      r << v unless r.include? v
    end
    random = r.join(",").gsub(",","")
    self.update_attributes(:password=>random, :password_confirmation => random)
    random
  end
  private
  def set_default_role
    self.role ||= :normal
  end
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.find_by(authentication_token: token)
    end
  end
end
