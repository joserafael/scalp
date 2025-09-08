class DashboardController < ApplicationController
  def index
    @stats = {
      total_trades: Trade.count,
      open_trades: Trade.open.count,
      matched_trades: Trade.matched.count,
      total_pairs: TradePair.count,
      total_profit: TradePair.sum(:profit)
    }
    
    @recent_trades = Trade.includes(:cryptocurrency)
                         .order(created_at: :desc)
                         .limit(10)
    
    @recent_pairs = TradePair.includes(:buy_trade, :sell_trade)
                            .order(created_at: :desc)
                            .limit(5)
    
    @open_trades_by_crypto = Trade.open
                                 .joins(:cryptocurrency)
                                 .group('cryptocurrencies.symbol')
                                 .count
    
    @profit_by_crypto = TradePair.joins(buy_trade: :cryptocurrency)
                                .group('cryptocurrencies.symbol')
                                .sum(:profit)
  end
end