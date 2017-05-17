# == Schema Information
#
# Table name: conference_papers
#
#  conference_paper_id :string(30)       not null, primary key
#  paper_id            :string(30)
#  conference_id       :string(30)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_conference_papers_on_conference_paper_id         (conference_paper_id) UNIQUE
#  index_conference_papers_on_paper_id_and_conference_id  (paper_id,conference_id) UNIQUE
#
class ConferencePaper < ApplicationRecord
  belongs_to :conference
  belongs_to :paper

  has_many :similarities, class_name: 'Similarity', foreign_key: :conference_paper_id, primary_key: :conference_id, dependent: :destroy

  before_create :init_id

  self.primary_key = :conference_paper_id

  private

  # Create Conference Paper id
  def init_id
    self.id = CodeGenerator.code(ConferencePaper.new, ConferencePaper.primary_key.to_s, 30)
  end

end
