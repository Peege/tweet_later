class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    @tweet = Tweet.find(tweet_id)
    @user = @tweet.user

    @user.post_tweet(@tweet.text)
  end
end