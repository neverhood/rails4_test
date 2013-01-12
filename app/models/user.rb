class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  # Avatar cropping
  attr_accessor :crop_x, :crop_y, :crop_h, :crop_w

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Subscribable
  include Conversational

  validates :male, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :login, uniqueness: true, length: { within: (3..20) }, allow_nil: true, format: { with: /\A[A-Za-z]+[A-Za-z_-]*[A-Za-z]+\z/ }

  has_many :albums, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :news_feed_entries, :dependent => :destroy

  # This scope is to be used on collections to avoid loading unneeded attributes
  scope :previews, -> amount = 10 { select('users.id', 'users.name', 'users.male', 'users.avatar', 'users.details').limit(amount) }

  before_validation -> { self.login.downcase! }, if: -> { self.login_changed? }
  after_update      -> { self.avatar.recreate_versions! }, if: -> { self.cropping? }

  def details
    @details ||= OpenStruct.new(read_attribute(:details))
  end

  def sex
    male?? :male : :female
  end

  def cropping?
    crop_x.present? and crop_y.present? and crop_h.present? and crop_w.present?
  end
end
