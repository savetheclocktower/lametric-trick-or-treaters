# An app for keeping track of trick-or-treaters.
# 
# Hit /increment to increment the trick-or-treater count.
# Hit /set to change the count manually.
# Hit /reset to change it to 0.
# 
# The /lametric endpoint is what the device hits. It expects formatted JSON.

require 'sinatra'
require 'redis'
require 'json'

$redis = Redis.new( url: ENV['REDIS_URL'] )

KEY = 'trick_or_treaters'
GHOST_ICON = 'a77'

LAMETRIC_JSON = {
  frames: [
    {
      index: 0,
      text: "trick or treat",
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

def reset_count
  $redis.set(KEY, 0)
end

get '/' do
  erb :index
end

get '/increment' do
  increment_count
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