# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Criar criptomoedas populares
cryptocurrencies = [
  { name: 'Bitcoin', symbol: 'BTC' },
  { name: 'Ethereum', symbol: 'ETH' },
  { name: 'Binance Coin', symbol: 'BNB' },
  { name: 'Cardano', symbol: 'ADA' },
  { name: 'Solana', symbol: 'SOL' },
  { name: 'Polkadot', symbol: 'DOT' },
  { name: 'Dogecoin', symbol: 'DOGE' },
  { name: 'Avalanche', symbol: 'AVAX' },
  { name: 'Polygon', symbol: 'MATIC' },
  { name: 'Chainlink', symbol: 'LINK' }
]

cryptocurrencies.each do |crypto_data|
  Cryptocurrency.find_or_create_by!(symbol: crypto_data[:symbol]) do |crypto|
    crypto.name = crypto_data[:name]
    crypto.active = true
  end
end

puts "Criadas #{Cryptocurrency.count} criptomoedas"

# Criar usuários
users = [
  { name: 'João Silva' },
  { name: 'Maria Santos' },
  { name: 'Pedro Oliveira' },
  { name: 'Ana Costa' },
  { name: 'Carlos Ferreira' }
]

users.each do |user_data|
  User.find_or_create_by!(name: user_data[:name])
end

puts "Criados #{User.count} usuários"