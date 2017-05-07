# == Schema Information
#
# Table name: conference_papers
#
# *id*::            <tt>integer, not null, primary key</tt>
# *paper_id*::      <tt>string(30)</tt>
# *conference_id*:: <tt>string(30)</tt>
# *created_at*::    <tt>datetime, not null</tt>
# *updated_at*::    <tt>datetime, not null</tt>
#
# Indexes
#
#  index_conference_papers_on_paper_id_and_conference_id  (paper_id,conference_id) UNIQUE
#--
# == Schema Information End
#++

class ConferencePaper < ApplicationRecord
  belongs_to :conference
  belongs_to :paper

  has_many :similarities, class_name: 'Similarity', foreign_key: :conference_paper_id, primary_key: :conference_id

  before_create :init_id

  private

  def init_id
    self.id = CodeGenerator.code(ConferencePaper.new, 'id', 30)
  end

end
