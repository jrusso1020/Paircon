# == Schema Information
#
# Table name: conference_attendees
#
#  id            :string(30)       not null, primary key
#  conference_id :string(30)
#  user_id       :string(30)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_conference_attendees_on_user_id_and_conference_id  (user_id,conference_id) UNIQUE
#

# Model responsible for ConferenceAttendee objects
class ConferenceAttendee < ApplicationRecord
  belongs_to :conference
  belongs_to :user
  before_create :init_id

  self.primary_key = :conference_attendee_id

  private

  # Create Conference Attendee id
  def init_id
    self.id = CodeGenerator.code(ConferenceAttendee.new, ConferenceAttendee.primary_key.to_s, 30)
  end

end
