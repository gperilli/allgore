class Movie < ApplicationRecord
  has_many :movielistconnectors


  validates :title, presence: true, uniqueness: true
  validates :overview, presence: true
end
