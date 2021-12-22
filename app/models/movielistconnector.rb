class Movielistconnector < ApplicationRecord
  belongs_to :movie
  belongs_to :list
end
