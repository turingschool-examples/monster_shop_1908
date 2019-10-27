require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @user_1 = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Hershey", state: "CO", zip: 23840, email: "test1@gmail.com", password: "password123", password_confirmation: "password123")
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = Order.create!(user_id: @user.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      expect(@meg.average_item_price).to eq(65)
    end

    it 'distinct_cities' do
      order_1 = Order.create!(user_id: @user.id)
      order_2 = Order.create!(user_id: @user_1.id)
      order_3 = Order.create!(user_id: @user.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to eq(['Denver', 'Hershey']).or eq(['Hershey', 'Denver'])
    end

    describe 'class methods' do
      it 'can get all orders pertaining to a merchant' do
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
        @dog_bone = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

        user_1 = User.create(name: 'Kyle Pine', address: '123 Main Street', city: 'Greenville', state: 'NC', zip: '29583', email: 'billybob@hotmail.com', password: 'reallysecurepassword', password_confirmation: 'reallysecurepassword')
        order_1 = user_1.orders.create
        order_1.item_orders.create(item_id: @tire.id, quantity: 2, price: 50)

        user_2 = User.create(name: 'Steve Spruce', address: '456 2nd Street', city: 'Redville', state: 'SC', zip: '29444', email: 'snowsurferspruce@gmail.com', password: 'reallysecurepassword', password_confirmation: 'reallysecurepassword')
        order_2 = user_2.orders.create
        order_2.item_orders.create(item_id: @pull_toy.id, quantity: 2, price: 20)
        order_2.item_orders.create(item_id: @dog_bone.id, quantity: 1, price: 20)

        user_3 = User.create(name: 'Steve Spruce', address: '456 2nd Street', city: 'Redville', state: 'SC', zip: '29444', email: 'snowsurferspruce1@gmail.com', password: 'reallysecurepassword', password_confirmation: 'reallysecurepassword')
        order_3 = user_3.orders.create
        order_3.item_orders.create(item_id: @pull_toy.id, quantity: 2, price: 20)
        order_3.item_orders.create(item_id: @dog_bone.id, quantity: 1, price: 20)

        expect(@meg.orders).to eq([order_1, order_2, order_3])
      end
    end
  end
end
