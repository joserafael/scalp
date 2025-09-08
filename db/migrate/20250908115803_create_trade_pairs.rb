class CreateTradePairs < ActiveRecord::Migration[8.0]
  def change
    create_table :trade_pairs do |t|
      t.references :buy_trade, null: false, foreign_key: { to_table: :trades }
      t.references :sell_trade, null: false, foreign_key: { to_table: :trades }
      t.decimal :profit, precision: 15, scale: 8, null: false

      t.timestamps
    end
    
    add_index :trade_pairs, :profit
  end
end
