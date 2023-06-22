class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :detail, presence: true, length: { maximum: 255 }

  enum status: { not_started: 0, started: 1, completed: 2 }
  enum priority: { high: 0, middle: 1, low: 2 }

  scope :by_created_at, -> { order(created_at: :desc) }
  scope :by_expired_at, -> { order(expired_at: :desc) }
  scope :by_priority, -> { order(priority: :asc) }
  scope :search_word, ->(search) { where("title LIKE ?", "%#{search}%") }
  scope :search_status, ->(status) { where(status: status) }

  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings
end
