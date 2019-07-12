class Relationship < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :sending, class_name: "User"
  validates :sender_id, presence: true
  validates :sending_id, presence: true
end
