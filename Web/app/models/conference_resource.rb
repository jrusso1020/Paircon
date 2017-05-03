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

  def init_id
    self.id = CodeGenerator.code(ConferenceResource.new, 'id', 30)
  end

end
