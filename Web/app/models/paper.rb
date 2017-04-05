class Paper < ApplicationRecord
  has_many :paper_authors
  has_many :conference_papers
  has_many :similiarities
  has_many :users, through: :paper_authors
  has_many :conferences, through: :conference_papers
end
