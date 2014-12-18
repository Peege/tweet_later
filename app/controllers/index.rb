get '/' do
  # Look in app/views/index.erb
  # session.clear
  if session[:username]
    @user = User.find_by_nickname(session[:username])
  end
  erb :index
end
