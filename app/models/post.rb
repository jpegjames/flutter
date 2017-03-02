class Post < ApplicationRecord
  belongs_to :user
  has_many :likes

  # attribute :body, :integer

  validates :body, presence: true
end
