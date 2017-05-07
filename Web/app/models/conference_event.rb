# == Schema Information
#
# Table name: conference_events
#
#  id                     :string(30)       not null, primary key
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
#  paper_id               :string
#
# Indexes
#
#  index_conference_events_on_conference_resource_id  (conference_resource_id)
#

class ConferenceEvent < ApplicationRecord
  belongs_to :conference
  belongs_to :conference_resource
  before_create :init_id

  enum event_type: [:presentation, :keynote, :poster, :other]

  def end_date_str
    self.end_date.strftime(DATEFORMAT)
  end

  def start_date_str
    self.start_date.strftime(DATEFORMAT)
  end

  private

  def init_id
    self.id = CodeGenerator.code(ConferenceEvent.new, 'id', 30)
  end

end
