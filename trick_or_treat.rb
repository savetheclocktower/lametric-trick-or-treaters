# An app for keeping track of trick-or-treaters.
# 
# Hit /increment to increment the trick-or-treater count by 1.
# Hit /increment_by/X to add X to the total.
# Hit /set/X to change the count manually.
# Hit /reset to change it to 0.
# 
# The /lametric endpoint is what the device hits. It expects formatted JSON.

require 'sinatra'
require 'redis'
require 'json'
require 'pp'

$redis = Redis.new( url: ENV['REDIS_URL'] )

KEY = 'trick_or_treaters'
GHOST_ICON = 'a77'

LAMETRIC_JSON = {
  frames: [
    {
      index: 0,
      text: "sorry... we ran out",
      # text: "trick or treat",
      icon: GHOST_ICON
    }
  ]
}

def get_count
  $redis.get(KEY).to_i
end

def increment_count
  $redis.incr(KEY).to_i
end

def increment_count_by(amount)
  $redis.incrby(KEY, amount).to_i
end

def reset_count
  $redis.set(KEY, 0)
end

get '/' do
  erb :index, { locals: { count: get_count.to_s } }
end

post '/increment' do
  increment_count
  get_count.to_s
end

get '/increment' do
  increment_count
  get_count.to_s
end

post '/increment_by/:value' do
  increment_count_by(params['value'].to_i)
  get_count.to_s
end

get '/increment_by/:value' do
  increment_count_by(params['value'].to_i)
  get_count.to_s
end

get '/reset' do
  reset_count
  get_count.to_s
end

get '/set/:value' do
  $redis.set(KEY, params['value'].to_i)
  get_count.to_s
end

get '/lametric' do
  # Quick-and-dirty way of duplicating the data structure.
  json = JSON.parse( JSON.dump(LAMETRIC_JSON) )
  json['frames'].push({
    index: 1,
    text: "#{get_count.to_s} served",
    icon: nil
  })
  
  JSON.generate(json, indent: " ", space: " ")
end