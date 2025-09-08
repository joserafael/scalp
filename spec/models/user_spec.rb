require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with a name' do
      user = User.new(name: 'João Silva')
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user = User.new(name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with an empty name' do
      user = User.new(name: '')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many trades' do
      association = described_class.reflect_on_association(:trades)
      expect(association.macro).to eq :has_many
    end

    it 'destroys associated trades when user is destroyed' do
       user = User.create!(name: 'Test User')
       cryptocurrency = Cryptocurrency.create!(name: 'Bitcoin', symbol: 'BTC')
       trade = Trade.create!(
         cryptocurrency: cryptocurrency,
         operation_type: 'buy',
         quantity: 1.0,
         unit_price: 50000.0,
         total_value: 50000.0,
         user: user
       )
       
       expect { user.destroy! }.to change { Trade.count }.by(-1)
     end
  end

  describe 'factory' do
    it 'has a valid factory' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end
end
