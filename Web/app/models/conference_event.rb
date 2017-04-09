class ConferenceEvent < ApplicationRecord
  belongs_to :conference
  belongs_to :conference_resource
  before_create :init_id

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
