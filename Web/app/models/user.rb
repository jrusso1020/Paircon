class User < ApplicationRecord

  devise :database_authenticatable, :async, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable, :omniauthable,
         omniauth_providers: [:google_oauth2, :facebook]

  validates :email, presence: true
  validates :password, confirmation: true

  has_many :identities, dependent: :destroy
  has_many :conferences, through: :conference_attendees, dependent: :destroy
  has_many :conferences, through: :conference_organizers, dependent: :destroy
  has_many :papers, through: :paper_authors

  has_attached_file :logo, styles: {medium: '300x300>', thumb: '100x100>'}, default_url: 'Male.jpg'
  validates_attachment :logo, content_type: {content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']}

  before_create :init_user_id

  enum user_type: [ :attendee, :organizer, :admin ]

  def full_name=(full_name)
    full_name_tokens = full_name.split(/\s+/)

    self.first_name = full_name_tokens[0]
    self.last_name = full_name_tokens[1..-1].join(' ') if (full_name_tokens.size > 0)
  end

  def full_name
    "#{self.first_name} #{self.last_name}".strip()
  end

  def profile_photo
    if !self.logo_file_name.blank?
      return self.logo.try(:url)
    elsif self.gender == 0
      return 'Female.jpg'
    else
      return 'Male.jpg'
    end
  end

  def profile_photo_full_link
    return "#{PairConConfig::root_domain + ActionController::Base.helpers.asset_path(self.profile_photo)}"
  end

  def get_pdf_text_path
    return "#{Rails.root}/public/docs/txt/#{self.id}"
  end

  def get_pdf_folder_path
    return "#{Rails.root}/public/docs/pdfs/#{self.id}"
  end

  def pending_organizer
    Organizer.exists?(user_id: self.id)
  end

  private

  def init_user_id
    self.id = CodeGenerator.code(User.new, 'id', 30)
  end

end
