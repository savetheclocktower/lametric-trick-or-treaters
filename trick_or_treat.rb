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

get '/' do
  "Hello World!"
end

get '/increment' do
  increment_count
  get_count.to_s
end