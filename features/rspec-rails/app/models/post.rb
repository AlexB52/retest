class Post < ApplicationRecord
  validates :title, presence: true
end
