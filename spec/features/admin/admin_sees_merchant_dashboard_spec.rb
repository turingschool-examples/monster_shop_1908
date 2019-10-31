require 'rails_helper'

describe 'As an admin user' do
  describe 'When I visit the merchant index page, /merchants' do
    describe 'When I click a merchants name' do
      before(:each) do
        @admin_user = User.create(name: "Bob G",
          street_address: "123 Avenue",
          city: "Portland",
          state: "OR",
          zip: "30203",
          email: "bobg@agency.com",
          password: "bobg",
          password_confirmation: "bobg",
          role: 1)
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)

          @user = User.create(
            name: "Dee",
            street_address: "4233 Street",
            city: "Golden",
            state: "CO",
            zip: "80042",
            email: "deedee@gmail.com",
            password: "rainbows1908",
            role: 0)

          @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
          @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
          @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
          @order_1 = @user.orders.create(name: "Reg", address: "123 Street", city: "Denver", state: "CO", zip: "80202", user_id: @user.id, status: "Pending")
          @item_order_1 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, price: 20, quantity: 2)
          @item_order_2 = ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, price: 2, quantity: 101)

          visit '/merchants'
          click_link 'Mike'
      end

      it "I should be taken to /admin/merchants/id" do
        expect(current_path).to eq("/admin/merchants/#{@mike.id}")
      end

      it "I should see everything that a merchant would see on their dashboard" do
        expect(page).to have_content("Mike's Print Shop")
        expect(page).to have_content(@mike.address)
        expect(page).to have_content(@mike.city)
        expect(page).to have_content(@mike.state)
        expect(page).to have_content(@mike.zip)

        within "#order-#{@order_1.id}" do
          expect(page).to have_link("#{@order_1.id}")
          expect(page).to have_content(@order_1.created_at)
          expect(page).to have_content("Total Quantity: 103")
          expect(page).to have_content("Total Value: $242.00")
        end
      end
    end
  end
end