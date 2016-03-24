#!/usr/bin/env ruby
# app.rb
require 'sinatra'
require 'tilt/erb'
require 'haml'

class Tribality < Sinatra::Base
  set :port, 80
  get '/' do
	haml :index
  end
  get '/screenshots' do
	@files = Dir.entries("public/screenshots").select { |e|
		!e.match(/^\./)
	}.sort
	haml :screenshots
  end

end
