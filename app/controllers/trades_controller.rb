class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :destroy]
  
  def index
    @trades = Trade.includes(:cryptocurrency)
                  .order(created_at: :desc)
    
    @open_trades = Trade.open.includes(:cryptocurrency)
    @matched_trades = Trade.matched.includes(:cryptocurrency)
    @trade_pairs = TradePair.includes(:buy_trade, :sell_trade)
                           .order(created_at: :desc)
    
    @total_profit = @trade_pairs.sum(:profit)
    @cryptocurrencies = Cryptocurrency.active.order(:name)
    
    respond_to do |format|
      format.html
      format.json { render json: { trades: @trades.map { |trade| trade_json(trade) } } }
    end
  end
  
  def show
  end
  
  def new
    @trade = Trade.new
    @open_trades_by_crypto = Trade.joins(:cryptocurrency)
                                  .where(status: 'open')
                                  .includes(:cryptocurrency)
                                  .group_by { |t| t.cryptocurrency.name }
  end
  
  def create
    @trade = Trade.new(trade_params)
    
    respond_to do |format|
      if @trade.save
        # Executar matching automático
        TradeMatchingService.new(@trade).perform
        
        format.html { redirect_to trades_path, notice: 'Operação criada com sucesso!' }
        format.json { render json: { status: 'success', trade: trade_json(@trade), message: 'Operação criada com sucesso!' } }
      else
        @open_trades_by_crypto = Trade.joins(:cryptocurrency)
                                      .where(status: 'open')
                                      .includes(:cryptocurrency)
                                      .group_by { |t| t.cryptocurrency.name }
        
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { status: 'error', errors: @trade.errors.full_messages } }
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if @trade.status == 'open'
        @trade.destroy
        format.html { redirect_to trades_path, notice: 'Operação excluída com sucesso!' }
        format.json { render json: { status: 'success', message: 'Operação excluída com sucesso!' } }
      else
        format.html { redirect_to trades_path, alert: 'Não é possível excluir operações já pareadas.' }
        format.json { render json: { status: 'error', message: 'Não é possível excluir operações já pareadas.' } }
      end
    end
  end
  
  def stats
    render json: calculate_stats
  end
  
  private
  
  def set_trade
    @trade = Trade.find(params[:id])
  end
  
  def trade_params
    params.require(:trade).permit(:cryptocurrency_id, :operation_type, :total_value, :unit_price, :quantity)
  end
  
  def trade_json(trade)
    {
      id: trade.id,
      cryptocurrency: trade.cryptocurrency.to_s,
      operation_type: trade.operation_type,
      total_value: trade.total_value.to_f,
      unit_price: trade.unit_price.to_f,
      quantity: trade.quantity.to_f,
      status: trade.status,
      created_at: trade.created_at.strftime('%d/%m/%Y %H:%M')
    }
  end
  
  def calculate_stats
    {
      total_trades: Trade.count,
      open_trades: Trade.open.count,
      matched_trades: Trade.matched.count,
      total_pairs: TradePair.count,
      total_profit: TradePair.sum(:profit).to_f,
      open_trades_list: Trade.open.includes(:cryptocurrency).map { |t| trade_json(t) },
      recent_pairs: TradePair.includes(:buy_trade, :sell_trade)
                            .order(created_at: :desc)
                            .limit(5)
                            .map do |pair|
        {
          id: pair.id,
          buy_trade: trade_json(pair.buy_trade),
          sell_trade: trade_json(pair.sell_trade),
          profit: pair.profit.to_f,
          created_at: pair.created_at.strftime('%d/%m/%Y %H:%M')
        }
      end
    }
  end
end