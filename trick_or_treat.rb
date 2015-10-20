require 'sinatra'
require 'redis'

$redis = Redis.new( url: ENV['REDIS_URL'] )

KEY = 'trick_or_treaters'

def get_count
  $redis.get(KEY).to_i
end

def increment_count
  $redis.incr(KEY).to_i
end

def reset_count
  $redis.set(KEY, 0)
end

get '/' do
  "Hello World!"
end

get '/increment' do
  increment_count
  get_count.to_s
end

get '/reset' do
  reset_count
  get_count.to_s
end