class User < ApplicationRecord
  has_many :trades, dependent: :destroy
  
  validates :name, presence: true
end
