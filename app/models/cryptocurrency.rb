class Cryptocurrency < ApplicationRecord
  has_many :trades, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :symbol, presence: true, uniqueness: true
  
  scope :active, -> { where(active: true) }
  
  def to_s
    "#{name} (#{symbol})"
  end
end