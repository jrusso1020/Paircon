class ConferenceResource < ApplicationRecord
  belongs_to :conference
  has_many :conference_events
  before_create :init_id

  TYPE = {
      auditorium: 'auditorium',
      room: 'room'
  }

  private

  def init_id
    self.id = CodeGenerator.code(ConferenceResource.new, 'id', 30)
  end

end
