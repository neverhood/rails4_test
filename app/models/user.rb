class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  # Avatar cropping
  attr_accessor :crop_x, :crop_y, :crop_h, :crop_w

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :male, presence: true
  validates :login, uniqueness: true, length: { within: (3..20) }, allow_nil: true, format: { with: /\A[A-Za-z]+[_-]*[A-Za-z]+\z/ }

  before_validation -> { self.login.downcase! }, if: -> { self.login_changed? }
  after_update      -> { self.avatar.recreate_versions! }, if: -> { self.cropping? }


  def sex
    male?? :male : :female
  end

  def cropping?
    crop_x.present? and crop_y.present? and crop_h.present? and crop_w.present?
  end
end
