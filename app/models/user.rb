class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  has_many :tasks, dependent: :destroy

  before_update :unable_update_admin
  before_update :unable_destroy_admin

  private

  def unable_update_admin
    @admin = User.where(admin: true)
    if @admin.count == 1 && self.admin == false
      throw :abort
    end
  end

  def unable_destroy_admin
    @admin = User.where(admin: true)
    if @admin.count == 1 && self.admin == true
      throw :abort
    end
  end
end
