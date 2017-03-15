class PaperAuthor < ApplicationRecord
  alias_attribute :authors, :users
  has_many :papers, :users
end
