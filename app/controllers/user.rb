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
  User.find_by_nickname(session[:username]).tweet(params[:tweet])
  redirect to ('/')
end

get '/status/:job_id' do
  # return the status of a job to an AJAX call

  job_is_complete(params[:job_id]).to_s
end

post '/post_tweet_later' do
  User.find_by_nickname(session[:username]).post_tweet_later(params[:tweet], params[:time])

  redirect to ('/')
end