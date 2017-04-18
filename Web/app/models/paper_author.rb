# == Schema Information
#
# Table name: paper_authors
#
# *id*::                 <tt>string(30), not null, primary key</tt>
#   t.string   "name"
#   t.string   "affiliation"
#   t.string   "paper_id"
#   t.datetime "created_at",  null: false
#   t.datetime "updated_at",  null: false
#--
# == Schema Information End
#++


class PaperAuthor < ApplicationRecord
  belongs_to :paper
  before_create :init_id
  private

  def init_id
    self.id = CodeGenerator.code(PaperAuthor.new, 'id', 30)
  end

end
