class PaperAuthor < ApplicationRecord
  alias_attribute :authors, :users
  belongs_to :paper
  belongs_to :user
end
