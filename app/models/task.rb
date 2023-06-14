class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255}
  validates :detial, presence: true, length: { maximum: 255}
end
