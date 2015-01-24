class Participant < ActiveRecord::Base
  has_many :studies
  has_many :users, through: :studies

  accepts_nested_attributes_for :studies
end
