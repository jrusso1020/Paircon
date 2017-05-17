# == Schema Information
#
# Table name: conference_events
#
#  conference_event_id    :string(30)       not null, primary key
#  conference_resource_id :string(30)
#  title                  :string
#  start_date             :datetime
#  end_date               :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  color                  :string
#  conference_id          :string(30)
#  presenter              :string
#  event_type             :integer          default("presentation")
#  paper_id               :string(30)
#
# Indexes
#
#  index_conference_events_on_conference_event_id     (conference_event_id) UNIQUE
#  index_conference_events_on_conference_resource_id  (conference_resource_id)
#
class ConferenceEvent < ApplicationRecord
  belongs_to :conference
  belongs_to :conference_resource
  before_create :init_id

  enum event_type: [:presentation, :keynote, :poster, :other]

  self.primary_key = :conference_event_id

  # Get string of conference end date
  # @return [String] String format for End Date
  def end_date_str
    self.end_date.strftime(DATETIMEFORMAT)
  end

  # Get string of conference start date
  # @return [String] String format for Start Date
  def start_date_str
    self.start_date.strftime(DATETIMEFORMAT)
  end

  private

  # Create a Conference Event id
  def init_id
    self.id = CodeGenerator.code(ConferenceEvent.new, ConferenceEvent.primary_key.to_s, 30)
  end

end
