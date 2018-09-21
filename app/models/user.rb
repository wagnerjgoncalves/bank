class User < ApplicationRecord
  validates :email, :name, presence: true
  validates :email, uniqueness: true
end
