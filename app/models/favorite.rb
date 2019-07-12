class Favorite < ApplicationRecord
  belongs_to :liker, class_name: "User"
  belongs_to :liking, class_name: "User"
  validates :liker_id, presence: true
  validates :liking_id, presence: true
end
