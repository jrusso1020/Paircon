# == Schema Information
#
# Table name: conference_organizers
#
# *id*::            <tt>integer, not null, primary key</tt>
# *conference_id*:: <tt>integer</tt>
# *user_id*::       <tt>integer</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class ConferenceOrganizer < ApplicationRecord
  alias_attribute :organizers, :users
  has_many :conferences
  has_many :users
end
