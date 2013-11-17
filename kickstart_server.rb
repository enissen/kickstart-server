require "rubygems"
require "sinatra/base"
require "yaml"
require "json"

#require_relative 'helpers/response_constructor'

class KickstartServer < Sinatra::Base

  get '/' do
    "I\'m here to serve you!"
  end


  # returns all requirements that are needed for using 
  # the grid as json object. This includes actual versioning.
  #
  get '/requirements.json' do
  	content_type :json
    YAML::load(File.open(File.join('lib', 'requirements.yml'))).to_json
  end


  get '/update/:node' do
    "#{params[:node]}"
  end

end