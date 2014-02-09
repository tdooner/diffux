require 'heroku-api'
require 'sidekiq/api'
require 'json'
require 'open-uri'

client = Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
status = JSON.parse(open('http://diffux.herokuapp.com/heroku_status/queue').read)
count = client.get_ps(ENV['HEROKU_APP_NAME']).data[:body].count { |h| h['process'] =~ /worker/ }

puts status
puts "count: #{count}"

if (status['queue'] + status['workers']) == 0
  if count > 0
    client.post_ps_scale(ENV['HEROKU_APP_NAME'], 'worker', 0)
  end
else count == 0
  client.post_ps_scale(ENV['HEROKU_APP_NAME'], 'worker', 1)
end
