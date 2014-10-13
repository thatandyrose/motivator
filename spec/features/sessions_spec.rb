require 'spec_helper'

describe SessionsController do

  before do
    mock_auth({ name: 'Bob', uid: '12345' })
  end

  describe "creates new user" do
    it "redirects new users with blank email to fill in their email" do
      visit '/signin'
      page.should have_content('Hey Bob')
      page.should have_content('Please enter your email address')
      current_path.should == edit_user_path(User.first)
    end

    it "redirects users with email back to motees create page" do
      @user = FactoryGirl.create(:user, email:"Tester@testing.com", uid:'12345',provider:'facebook')
      visit '/signin'
      page.should have_content('Signed in!')
      current_path.should == new_motee_path
    end
  end

end
