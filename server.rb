require 'sinatra'
require 'json'
require 'pry'

set :port, 1234

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/:file' do
  path = "/Users/monsterlite/Games/pipes/public/"
  send_file "#{path}#{params[:file]}", disposition: 'inline'
end

options '/save/:level/:pipes' do
  i     = params['level'].to_i
  l     = i.to_s.rjust 3, "0"
  pipes = params['pipes']
  pipes = pipes.split(',')
  pipes = pipes.map {|p|
    p == 'null' ? p : "'#{p}'"
  }
  pipes = pipes.join(',')

  path  = "/Users/monsterlite/Games/pipes/source/javascripts/levels/l#{l}.js"
  json = "_l[#{i}] = {countdown: 10, speed: 5, pipes: [#{pipes}]}"

  File.open(path, 'w') { |f| f.write(json) }

  content_type :json
  {success: true}.to_json
end
