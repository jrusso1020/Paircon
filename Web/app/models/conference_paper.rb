class ConferencePaper < ApplicationRecord
  belongs_to :conference
  belongs_to :paper
end
