# == Schema Information
#
# Table name: identities
#
# *id*::         <tt>integer, not null, primary key</tt>
# *user_id*::    <tt>string(30)</tt>
# *provider*::   <tt>string</tt>
# *uid*::        <tt>string</tt>
# *auth_data*::  <tt>text</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#
# Indexes
#
#  index_identities_on_user_id  (user_id)
#--
# == Schema Information End
#++

class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  serialize :auth_data, JSON
  before_create :init_id

  def auth
    Hashie::Mash.new auth_data
  end

  %w(first_name last_name email image).each do |attr|
    define_method attr do
      auth.info.send(attr) || attr.to_s #raise("Could not find #{attr} in #{auth}")
    end
  end

  private

  def init_id
    self.id = CodeGenerator.code(Identity.new, 'id', 30)
  end
end
