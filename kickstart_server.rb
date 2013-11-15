require "rubygems"
require "sinatra/base"
require "yaml"
require "json"

class KickstartServer < Sinatra::Base

  get '/' do
    "I\'m here to serve you!"
  end


  # returns the requirements of the grid as
  # json object
  #
  get '/requirements.json' do
  	content_type :json
    YAML::load(File.open(File.join('lib', 'requirements.yml'))).to_json
  end

end