# Superclass for Models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
