# == Schema Information
#
# Table name: identities
#
#  identity_id :string(30)       not null, primary key
#  user_id     :string(30)
#  provider    :string
#  uid         :string
#  auth_data   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_identities_on_identity_id  (identity_id) UNIQUE
#  index_identities_on_user_id      (user_id)
#
class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  serialize :auth_data, JSON
  before_create :init_id

  self.primary_key = :identity_id

  # Used to generated hash from Authentication Data
  def auth
    Hashie::Mash.new auth_data
  end

  %w(first_name last_name email image).each do |attr|
    define_method attr do
      auth.info.send(attr) || attr.to_s #raise("Could not find #{attr} in #{auth}")
    end
  end

  private

  # Create Identity id
  def init_id
    self.id = CodeGenerator.code(Identity.new, Identity.primary_key.to_s, 30)
  end
end
