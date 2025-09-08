class AddUserToTrades < ActiveRecord::Migration[8.0]
  def change
    add_reference :trades, :user, null: true, foreign_key: true
  end
end
