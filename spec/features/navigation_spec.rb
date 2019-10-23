
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within('nav') { click_link 'Home' }
      expect(current_path).to eq('/')

      within('nav') { click_link 'Items' }
      expect(current_path).to eq('/items')

      within('nav') { click_link 'Merchants' }
      expect(current_path).to eq('/merchants')

      within('nav') { click_link 'Login' }
      expect(current_path).to eq('/login')

      within('nav') { click_link 'Register' }
      expect(current_path).to eq('/register')

    end

    it "I cannot see links I'm not authorized for" do
      visit '/items'

      within('nav') do
        expect(page).to_not have_link 'Logout'
        expect(page).to_not have_link 'Profile'
        expect(page).to_not have_link 'Dashboard'
        expect(page).to_not have_content 'Logged in as'
      end
    end


    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within('nav') { expect(page).to have_content("Cart (0)") }

      visit '/items'

      within('nav') { expect(page).to have_content("Cart (0)") }
    end
  end

  describe "As a default user" do
    before :each do
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")

      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'
    end

    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within('nav') { click_link 'Home' }
      expect(current_path).to eq('/')

      within('nav') { click_link 'Items' }
      expect(current_path).to eq('/items')

      within('nav') { click_link 'Merchants' }
      expect(current_path).to eq('/merchants')

      within('nav') { click_link 'Profile' }
      expect(current_path).to eq('/profile')

      within('nav') { click_link 'Logout' }
      expect(current_path).to eq('/')
    end

    it "I cannot see links I'm not authorized for" do
      visit '/items'

      within('nav') do
        expect(page).to_not have_link 'Login'
        expect(page).to_not have_link 'Register'
        expect(page).to_not have_link 'Dashboard'
      end
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within('nav') { expect(page).to have_content("Cart (0)") }

      visit '/items'

      within('nav') { expect(page).to have_content("Cart (0)") }
    end

    it "will display login name" do
      visit '/items'

      within('nav') { expect(page).to have_content("Logged in as Gmoney") }
    end
  end

end
