class TradePair < ApplicationRecord
  belongs_to :buy_trade, class_name: 'Trade'
  belongs_to :sell_trade, class_name: 'Trade'
  
  validates :profit, presence: true, numericality: { greater_than: 0 }
  validates :buy_trade_id, uniqueness: true
  validates :sell_trade_id, uniqueness: true
  
  validate :trades_are_compatible
  validate :profit_calculation_is_correct
  
  before_validation :calculate_profit
  after_create :mark_trades_as_matched
  after_destroy :mark_trades_as_open
  
  scope :by_profit_asc, -> { order(:profit) }
  scope :by_profit_desc, -> { order(profit: :desc) }
  
  def self.find_better_match_for(trade)
    return nil unless trade.open?
    
    if trade.buy?
      # Para uma compra, procura vendas que resultem em menor lucro
      compatible_sells = Trade.sell_orders.open
                             .where(cryptocurrency: trade.cryptocurrency)
                             .where(quantity: trade.quantity)
                             .where('unit_price > ?', trade.unit_price)
      
      return nil if compatible_sells.empty?
      
      # Encontra a venda com menor lucro
      best_sell = compatible_sells.min_by { |sell| sell.unit_price - trade.unit_price }
      
      # Verifica se existe um pareamento atual com lucro maior
      current_pair = TradePair.joins(:sell_trade)
                             .where(sell_trades: { 
                               cryptocurrency: trade.cryptocurrency,
                               quantity: trade.quantity,
                               unit_price: best_sell.unit_price..
                             })
                             .order(:profit)
                             .first
      
      return { sell_trade: best_sell, current_pair: current_pair } if current_pair
      
      { sell_trade: best_sell, current_pair: nil }
    else
      # Para uma venda, procura compras que resultem em menor lucro
      compatible_buys = Trade.buy_orders.open
                            .where(cryptocurrency: trade.cryptocurrency)
                            .where(quantity: trade.quantity)
                            .where('unit_price < ?', trade.unit_price)
      
      return nil if compatible_buys.empty?
      
      # Encontra a compra com menor lucro
      best_buy = compatible_buys.max_by { |buy| buy.unit_price }
      
      # Verifica se existe um pareamento atual com lucro maior
      current_pair = TradePair.joins(:buy_trade)
                             .where(buy_trades: { 
                               cryptocurrency: trade.cryptocurrency,
                               quantity: trade.quantity,
                               unit_price: ..best_buy.unit_price
                             })
                             .order(:profit)
                             .first
      
      return { buy_trade: best_buy, current_pair: current_pair } if current_pair
      
      { buy_trade: best_buy, current_pair: nil }
    end
  end
  
  private
  
  def trades_are_compatible
    return unless buy_trade && sell_trade
    
    unless buy_trade.can_match_with?(sell_trade)
      errors.add(:base, 'Trades are not compatible for matching')
    end
  end
  
  def profit_calculation_is_correct
    return unless buy_trade && sell_trade
    
    expected_profit = buy_trade.profit_with(sell_trade)
    if profit != expected_profit
      errors.add(:profit, "should be #{expected_profit}")
    end
  end
  
  def calculate_profit
    return unless buy_trade && sell_trade
    
    self.profit = buy_trade.profit_with(sell_trade)
  end
  
  def mark_trades_as_matched
    buy_trade.update!(status: 'matched')
    sell_trade.update!(status: 'matched')
  end
  
  def mark_trades_as_open
    buy_trade.update!(status: 'open')
    sell_trade.update!(status: 'open')
  end
end