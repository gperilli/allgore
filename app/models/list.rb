class List < ApplicationRecord
  has_many :movielistconnectors, dependent: :destroy
  has_many :movies, through: :movielistconnectors
  has_many :reviews

  validates :name, uniqueness: true, presence: true
end
