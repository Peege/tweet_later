class User < ActiveRecord::Base

  has_many :tweets

  validates :nickname, uniqueness: true
  validates :access_token, uniqueness: true
  validates :access_token_secret, uniqueness: true


  def self.find_or_create(user_info)
    if User.exists?(nickname: user_info.info.nickname)
         user = User.find_by_nickname(user_info.info.nickname)
         user.update(access_token: user_info.extra.access_token.token, access_token_secret: user_info.extra.access_token.secret)
         return user
    else
      user = User.create(nickname: user_info.info.nickname, access_token: user_info.extra.access_token.token, access_token_secret: user_info.extra.access_token.secret)
      user.fetch_tweets!
      return user
    end
  end

  def fetch_tweets!
    tweets = client.user_timeline(self.nickname, count: 10)
    tweets.reverse.each do |t|
      Tweet.create(user_id: self.id, text: t.text)
    end
  end

  def post_tweet(tweet)
    client.update(tweet)
    self.fetch_tweets!
  end


  private
  def client
    Twitter::REST::Client.new do |config|
    config.consumer_key        = "NVb91mqVpfPQpl5tpoA5s8QST"
    config.consumer_secret     = "okyPCq4n0WojdfwO0mbUtj6O9juZg1jhpvBPObP0vCNY1xZSjJ"
    config.access_token        = self.access_token
    config.access_token_secret = self.access_token_secret
    end
  end


end