class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  has_many :tasks, dependent: :destroy

  private

  before_destroy { throw(:abort) if User.where(admin: true).count <= 1 && self.admin? }
  before_update { throw(:abort) if User.where(admin: true).count <= 1 && self.admin? }


end
