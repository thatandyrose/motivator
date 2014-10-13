require 'spec_helper'

describe SessionsController do

  before do
    mock_auth({ name: 'Bob', uid: '12345' })
  end

  describe "GET 'new'" do
    it "redirectes users to authentication" do
      get 'new'
      assert_redirected_to '/auth/facebook'
    end
  end

end
