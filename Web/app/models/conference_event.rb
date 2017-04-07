class ConferenceEvent < ApplicationRecord
  belongs_to :conference_resource
  before_create :init_id

  private

  def init_id
    self.id = CodeGenerator.code(ConferenceEvent.new, 'id', 30)
  end

end
