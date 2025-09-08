class Trade < ApplicationRecord
  belongs_to :cryptocurrency
  belongs_to :user, optional: true
  has_one :buy_pair, class_name: 'TradePair', foreign_key: 'buy_trade_id', dependent: :destroy
  has_one :sell_pair, class_name: 'TradePair', foreign_key: 'sell_trade_id', dependent: :destroy
  
  enum :status, { open: 0, matched: 1 }
  
  validates :operation_type, presence: true, inclusion: { in: %w[buy sell] }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  

  scope :buy_orders, -> { where(operation_type: 'buy') }
  scope :sell_orders, -> { where(operation_type: 'sell') }
  

  
  def buy?
    operation_type == 'buy'
  end
  
  def sell?
    operation_type == 'sell'
  end
  
  def can_match_with?(other_trade)
    return false if other_trade == self
    return false if other_trade.cryptocurrency != cryptocurrency
    return false if other_trade.operation_type == operation_type
    return false if other_trade.matched?
    return false if matched?
    return false if other_trade.quantity != quantity
    
    # Só permite match se resultar em lucro
    if buy? && other_trade.sell?
      other_trade.unit_price > unit_price
    elsif sell? && other_trade.buy?
      unit_price > other_trade.unit_price
    else
      false
    end
  end
  
  def profit_with(other_trade)
    return 0 unless can_match_with?(other_trade)
    
    if buy? && other_trade.sell?
      (other_trade.unit_price - unit_price) * quantity
    elsif sell? && other_trade.buy?
      (unit_price - other_trade.unit_price) * quantity
    else
      0
    end
  end
  

end