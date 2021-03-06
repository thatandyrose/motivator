require 'spec_helper'

describe SessionsController do

  before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = {
        'uid' => '12345',
        'provider' => 'facebook',
        'info' => {
          'name' => 'Bob'
        }
      }
  end

  describe "GET 'new'" do
    it "redirectes users to authentication" do
      get 'new'
      assert_redirected_to '/auth/facebook'
    end
  end

  describe "creates new user" do
    it "redirects new users with blank email to fill in their email" do
      visit '/signin'
      page.should have_content('Hey Bob')
      page.should have_content('Please enter your email address')
      current_path.should == edit_user_path(User.first)
    end

    it "redirects users with email back to root_url" do
      @user = FactoryGirl.create(:user, email:"Tester@testing.com", uid:'12345',provider:'facebook')
      visit '/signin'
      page.should have_content('Signed in!')
      current_path.should == '/'
    end
  end

end
