def login(user)
  reset_session
  session[:user_id] = user.id
end

def logout
  reset_session
end