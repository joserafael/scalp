class CreateCryptocurrencies < ActiveRecord::Migration[8.0]
  def change
    create_table :cryptocurrencies do |t|
      t.string :name, null: false
      t.string :symbol, null: false
      t.boolean :active, default: true

      t.timestamps
    end
    
    add_index :cryptocurrencies, :name, unique: true
    add_index :cryptocurrencies, :symbol, unique: true
    add_index :cryptocurrencies, :active
  end
end
