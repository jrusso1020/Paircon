# == Schema Information
#
# Table name: conference_resources
#
#  id            :string(30)       not null, primary key
#  conference_id :string(30)
#  room          :string
#  title         :string
#  eventColor    :string
#  parent_id     :string(30)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_conference_resources_on_conference_id  (conference_id)
#  index_conference_resources_on_parent_id      (parent_id)
#

# Model responsible for ConferenceResource objects
class ConferenceResource < ApplicationRecord
  belongs_to :conference
  has_many :conference_events
  before_create :init_id
  attr_accessor :date
  attr_accessor :start_time
  attr_accessor :end_time
  attr_accessor :presenter
  attr_accessor :event_type
  attr_accessor :paper_id

  TYPE = {
      event: 'event',
      session: 'session'
  }

  private

  # Create Conference Resource id
  def init_id
    self.id = CodeGenerator.code(ConferenceResource.new, 'id', 30)
  end

end
