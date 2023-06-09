class Movie < ApplicationRecord
has_many :movielistconnectors
has_many :lists, through: :movielistconnectors

  validates :title, presence: true, uniqueness: true
  validates :overview, presence: true
end
