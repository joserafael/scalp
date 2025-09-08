require 'rails_helper'

RSpec.describe Trade, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      cryptocurrency = Cryptocurrency.create!(name: 'Bitcoin', symbol: 'BTC')
      trade = Trade.new(
        cryptocurrency: cryptocurrency,
        operation_type: 'buy',
        quantity: 1.0,
        unit_price: 50000.0,
        total_value: 50000.0
      )
      expect(trade).to be_valid
    end

    it 'is invalid without a cryptocurrency' do
      trade = Trade.new(
        operation_type: 'buy',
        quantity: 1.0,
        unit_price: 50000.0,
        total_value: 50000.0
      )
      expect(trade).to_not be_valid
      expect(trade.errors[:cryptocurrency]).to include("must exist")
    end

    it 'is invalid without an operation_type' do
      cryptocurrency = Cryptocurrency.create!(name: 'Bitcoin', symbol: 'BTC')
      trade = Trade.new(
        cryptocurrency: cryptocurrency,
        quantity: 1.0,
        unit_price: 50000.0,
        total_value: 50000.0
      )
      expect(trade).to_not be_valid
      expect(trade.errors[:operation_type]).to include("can't be blank")
    end

    it 'is invalid without quantity' do
      cryptocurrency = Cryptocurrency.create!(name: 'Bitcoin', symbol: 'BTC')
      trade = Trade.new(
        cryptocurrency: cryptocurrency,
        operation_type: 'buy',
        unit_price: 50000.0,
        total_value: 50000.0
      )
      expect(trade).to_not be_valid
      expect(trade.errors[:quantity]).to include("can't be blank")
    end

    it 'is invalid without unit_price' do
      cryptocurrency = Cryptocurrency.create!(name: 'Bitcoin', symbol: 'BTC')
      trade = Trade.new(
        cryptocurrency: cryptocurrency,
        operation_type: 'buy',
        quantity: 1.0,
        total_value: 50000.0
      )
      expect(trade).to_not be_valid
      expect(trade.errors[:unit_price]).to include("can't be blank")
    end
  end

  describe 'methods' do
    let(:cryptocurrency) { Cryptocurrency.create!(name: 'Bitcoin', symbol: 'BTC') }
    
    describe '#buy?' do
      it 'returns true for buy trades' do
        trade = Trade.create!(
          cryptocurrency: cryptocurrency,
          operation_type: 'buy',
          quantity: 1.0,
          unit_price: 50000.0,
          total_value: 50000.0
        )
        expect(trade.buy?).to be true
      end

      it 'returns false for sell trades' do
        trade = Trade.create!(
          cryptocurrency: cryptocurrency,
          operation_type: 'sell',
          quantity: 1.0,
          unit_price: 50000.0,
          total_value: 50000.0
        )
        expect(trade.buy?).to be false
      end
    end

    describe '#sell?' do
      it 'returns true for sell trades' do
        trade = Trade.create!(
          cryptocurrency: cryptocurrency,
          operation_type: 'sell',
          quantity: 1.0,
          unit_price: 50000.0,
          total_value: 50000.0
        )
        expect(trade.sell?).to be true
      end

      it 'returns false for buy trades' do
        trade = Trade.create!(
          cryptocurrency: cryptocurrency,
          operation_type: 'buy',
          quantity: 1.0,
          unit_price: 50000.0,
          total_value: 50000.0
        )
        expect(trade.sell?).to be false
      end
    end

    describe '#total_value' do
      it 'returns the stored total value' do
        trade = Trade.create!(
          cryptocurrency: cryptocurrency,
          operation_type: 'buy',
          quantity: 2.0,
          unit_price: 50000.0,
          total_value: 100000.0
        )
        expect(trade.total_value).to eq(100000.0)
      end
    end
  end
end