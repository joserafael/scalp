class TradeMatchingService
  def initialize(trade)
    @trade = trade
  end
  
  def perform
    return unless @trade.open?
    
    # Encontra possível match melhor (menor lucro)
    match_info = TradePair.find_better_match_for(@trade)
    return unless match_info
    
    if @trade.buy?
      handle_buy_trade_matching(match_info)
    else
      handle_sell_trade_matching(match_info)
    end
  end
  
  private
  
  def handle_buy_trade_matching(match_info)
    sell_trade = match_info[:sell_trade]
    current_pair = match_info[:current_pair]
    
    # Se existe um pareamento atual com lucro maior, desfaz ele
    if current_pair
      new_profit = @trade.profit_with(sell_trade)
      if new_profit < current_pair.profit
        current_pair.destroy!
        create_new_pair(@trade, sell_trade)
      end
    else
      # Verifica se a venda já está em um pareamento
      existing_pair = TradePair.find_by(sell_trade: sell_trade)
      if existing_pair
        new_profit = @trade.profit_with(sell_trade)
        if new_profit < existing_pair.profit
          existing_pair.destroy!
          create_new_pair(@trade, sell_trade)
        end
      else
        create_new_pair(@trade, sell_trade)
      end
    end
  end
  
  def handle_sell_trade_matching(match_info)
    buy_trade = match_info[:buy_trade]
    current_pair = match_info[:current_pair]
    
    # Se existe um pareamento atual com lucro maior, desfaz ele
    if current_pair
      new_profit = buy_trade.profit_with(@trade)
      if new_profit < current_pair.profit
        current_pair.destroy!
        create_new_pair(buy_trade, @trade)
      end
    else
      # Verifica se a compra já está em um pareamento
      existing_pair = TradePair.find_by(buy_trade: buy_trade)
      if existing_pair
        new_profit = buy_trade.profit_with(@trade)
        if new_profit < existing_pair.profit
          existing_pair.destroy!
          create_new_pair(buy_trade, @trade)
        end
      else
        create_new_pair(buy_trade, @trade)
      end
    end
  end
  
  def create_new_pair(buy_trade, sell_trade)
    TradePair.create!(
      buy_trade: buy_trade,
      sell_trade: sell_trade
    )
  end
end