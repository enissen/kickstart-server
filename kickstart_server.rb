require "rubygems"
require "sinatra/base"
require "yaml"
require "json"

require_relative 'helpers/response_constructor'

class KickstartServer < Sinatra::Base
  helpers ResponseConstructor

  get '/' do
    "I\'m here to serve you!"
  end


  # returns all requirements that are needed for using 
  # the grid as json object. This includes actual versioning.
  #
  get '/requirements' do
  	content_type :json
    YAML::load(File.open(File.join('lib', 'requirements.yml'))).to_json
  end


  get '/update/:node' do
    content_type :json
    update(params[:node]).to_json
  end


  get '/update/config/:node' do
    content_type :json
    node_basic_config(params[:node]).to_json
  end


  get '/download/*' do |filepath|
    file = File.join(filepath)
    send_file(file, disposition: 'attachment', filename: File.basename(file))
  end


  get '/node-config/*/*' do |node, ip|
    content_type :json
    #node_selenium_config(params[:node], params[:ip]).to_json
    node_selenium_config(node, ip)
  end

end