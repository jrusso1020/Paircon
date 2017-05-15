# == Schema Information
#
# Table name: conference_papers
#
#  id            :integer          not null, primary key
#  paper_id      :string(30)
#  conference_id :string(30)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_conference_papers_on_paper_id_and_conference_id  (paper_id,conference_id) UNIQUE
#

class ConferencePaper < ApplicationRecord
  belongs_to :conference
  belongs_to :paper

  has_many :similarities, class_name: 'Similarity', foreign_key: :conference_paper_id, primary_key: :conference_id, dependent: :destroy

  before_create :init_id

  private

  # Create Conference Paper id
  def init_id
    self.id = CodeGenerator.code(ConferencePaper.new, 'id', 30)
  end

end
