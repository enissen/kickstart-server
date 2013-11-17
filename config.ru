require "rubygems"
require "sinatra"

require File.expand_path '../kickstart_server.rb', __FILE__

disable :run
set :root, Pathname(__FILE__).dirname

run KickstartServer