# == Schema Information
#
# Table name: paper_authors
#
# *id*::         <tt>integer, not null, primary key</tt>
# *paper_id*::   <tt>integer</tt>
# *user_id*::    <tt>integer</tt>
# *created_at*:: <tt>datetime, not null</tt>
# *updated_at*:: <tt>datetime, not null</tt>
#--
# == Schema Information End
#++

class PaperAuthor < ApplicationRecord
  alias_attribute :authors, :users
  belongs_to :paper
  belongs_to :user
end
