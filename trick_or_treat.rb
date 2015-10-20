require 'sinatra'
require 'redis'
require 'json'

$redis = Redis.new( url: ENV['REDIS_URL'] )

KEY = 'trick_or_treaters'


LAMETRIC_JSON = {
  frames: [
    {
      index: 0,
      text: "trick",
      icon: ""
    },
    {
      index: 1,
      text: "or",
      icon: ""
    },
    {
      index: 2,
      text: "treat",
      icon: ""
    },
    {
      index: 3,
      text: "served:",
      icon: ""
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

get '/lametric' do
  json = JSON.parse( JSON.dump(LAMETRIC_JSON) )
  json['frames'].push({
    index: 4,
    text: get_count.to_s,
    icon: ""
  })
  
  JSON.generate(json, indent: " ", space: " ")
end