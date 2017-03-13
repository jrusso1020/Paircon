class PaperAuthor < ApplicationRecord
  has_many :users, :papers
end
