class CreateTrades < ActiveRecord::Migration[8.0]
  def change
    create_table :trades do |t|
      t.references :cryptocurrency, null: false, foreign_key: true
      t.string :operation_type, null: false
      t.decimal :total_value, precision: 15, scale: 8, null: false
      t.decimal :unit_price, precision: 15, scale: 8, null: false
      t.decimal :quantity, precision: 15, scale: 8, null: false
      t.integer :status, default: 0

      t.timestamps
    end
    
    add_index :trades, :operation_type
    add_index :trades, :status
    add_index :trades, [:cryptocurrency_id, :operation_type, :status]
  end
end
