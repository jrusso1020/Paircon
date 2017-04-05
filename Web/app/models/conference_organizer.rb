# == Schema Information
#
# Table name: conference_organizers
#
# *id*::            <tt>integer, not null, primary key</tt>
# *conference_id*:: <tt>string(30)</tt>
# *user_id*::       <tt>string(30)</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#
# Indexes
#
#  index_conference_organizers_on_user_id_and_conference_id  (user_id,conference_id) UNIQUE
#--
# == Schema Information End
#++

class ConferenceOrganizer < ApplicationRecord
  alias_attribute :organizers, :users
  belongs_to :conference
  belongs_to :user
end
