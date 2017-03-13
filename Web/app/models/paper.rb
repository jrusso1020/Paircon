class Paper < ApplicationRecord
  belongs_to :paper_author, :conference_paper, :similiarity
end
