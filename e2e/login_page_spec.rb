require 'capybara/rspec'
require_relative 'spec_helper'

RSpec.describe 'Login Tests' do
  before(:each) do
    @driver = Capybara::Session.new(:selenium)
    @driver.visit 'https://www.saucedemo.com/'
  end

  context "Login with correct username and password" do
    usernames = ['standard_user']
    password = 'secret_sauce'
    
    usernames.each do |username|
      it "should be able to login with username #{username} and password" do
        @driver.fill_in 'user-name', with: username
        @driver.fill_in 'password', with: password
        @driver.click_button('Login')

        expect(@driver).to have_selector('.inventory_list')
      end
    end
  end

  context "Login with incorrect password" do
    usernames = ['standard_user']
    wrong_password = 'wrong_password'
    
    usernames.each do |username|
      it "should not login with username #{username} and wrong password" do
        @driver.fill_in 'user-name', with: username
        @driver.fill_in 'password', with: wrong_password
        @driver.click_button('Login')

        expect(@driver).to have_selector('.error-message-container', text: "Epic sadface: Username and password do not match any user in this service")
      end
    end
  end

  context "Login with locked out user" do
    username = 'locked_out_user'
    password = 'secret_sauce'

    it "should show locked out message for username #{username}" do
      @driver.fill_in 'user-name', with: username
      @driver.fill_in 'password', with: password
      @driver.click_button('Login')

      expect(@driver).to have_selector('.error-message-container', text: "Epic sadface: Sorry, this user has been locked out.")
    end
  end
end
