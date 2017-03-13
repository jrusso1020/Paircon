class ConferencePaper < ApplicationRecord
  has_many :conferences, :papers
end
