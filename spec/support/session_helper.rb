def login(user)
  mock_auth({ name: user.name, uid: user.uid })
  visit signin_path
end

def logout
  session[:user_id] = nil
end

def mock_auth(options)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = {
      'uid' => options[:uid],
      'provider' => 'facebook',
      'info' => {
        'name' => options[:name]
      }
    }
end