# == Schema Information
#
# Table name: conference_organizers
#
#  conference_organizer_id :string(30)       not null, primary key
#  conference_id           :string(30)
#  user_id                 :string(30)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_conference_organizers_on_conference_organizer_id    (conference_organizer_id) UNIQUE
#  index_conference_organizers_on_user_id_and_conference_id  (user_id,conference_id) UNIQUE
#
class ConferenceOrganizer < ApplicationRecord
  alias_attribute :organizers, :users
  belongs_to :conference
  belongs_to :user

  before_create :init_id

  self.primary_key = :conference_organizer_id

  private

  # Create a Conference Organizer id
  def init_id
    self.id = CodeGenerator.code(ConferenceOrganizer.new, ConferenceOrganizer.primary_key.to_s, 30)
  end

end

