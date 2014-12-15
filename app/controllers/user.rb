get '/login' do
  session[:username] = true
  redirect to ("/auth/twitter") #route set up by Omniauth
end

get '/logout' do
  session[:username] = nil
  "You are now logged out"
  redirect to ('/')
end

get '/auth/twitter/callback' do #callback route handler

  env['omniauth.auth'] ? session[:username] = true : halt(401,'Not Authorized')
  "You are now logged in"

  @user = User.find_or_create(env['omniauth.auth'])
  session[:username] = @user.nickname
  redirect '/'
end

get '/auth/failure' do
  params[:message]
end

post '/tweet' do
  User.find_by_nickname(session[:username]).post_tweet(params[:tweet])
  erb :index
end