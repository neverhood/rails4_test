class User < ActiveRecord::Base
  include HstoreProcessible

  uses_hstore_accessor :details, with: {
    country_id: { default: nil, type: Fixnum }, city_id: { default: nil, type: Fixnum }
  }

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
  has_many :photo_comments, :dependent => :destroy
  has_many :news_feed_entries, :dependent => :destroy
  has_many :response_entries, :dependent => :destroy
  has_one  :profile, :dependent => :destroy
  has_many :profile_posts, :through => :profile, :dependent => :destroy

  # This scope is to be used on collections to avoid loading unneeded attributes
  scope :previews, -> amount = 10 { select('users.id', 'users.name', 'users.male', 'users.avatar', 'users.details').limit(amount) }

  before_validation -> { self.login.downcase! }, if: -> { self.login_changed? }
  after_update      -> { self.avatar.recreate_versions! }, if: -> { self.cropping? }
  after_create      -> { self.create_profile }

  def sex
    male?? :male : :female
  end

  def cropping?
    crop_x.present? and crop_y.present? and crop_h.present? and crop_w.present?
  end

  def country
    Country.find_by(id: details['country_id'])
  end

  def city
    City.find_by(id: details['city_id'])
  end
end
