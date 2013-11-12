require "rubygems"
require "sinatra/base"

class KickstartServer < Sinatra::Base

  get '/' do
    'Hello, nginx and unicorn!'
  end

end