#!/usr/bin/env ruby
# app.rb
require 'sinatra'
require 'tilt/erb'
require 'haml'
require 'mongo'
require "mongo_mapper"

class Tribality < Sinatra::Base
  set :port, 80
  require 'net/smtp'

  def send_email(to,opts={})
    opts[:server]      ||= 'localhost'
    opts[:from]        ||= 'no.fucking.clue@tribal.strangled.net'
    opts[:from_alias]  ||= 'Tribal Mailer'
    opts[:subject]     ||= "Tribality Contact from #{opts[:from_alias]}"
    opts[:body]        ||= "Really? They forgot a message too?"

    msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

    return Net::SMTP.start(opts[:server], 25, "tribality") do |smtp|
      smtp.send_message msg, opts[:from], to
    end
  end

  get '/' do
	haml :index
  end
  get '/screenshots' do
	@files = Dir.entries("public/screenshots").select { |e|
		!e.match(/^\./)
	}.sort
	haml :screenshots
  end
  get '/contact' do
	haml :contact
  end
  post '/contact' do
	url = "127.0.0.1:27017"
	mongo = Mongo::Client.new([url], :database => "tribality")
        contact = mongo[:contact]	
	params["time"] = Time.now.to_i
	success = contact.insert_one(params)
	send_email("syzygy.antithesis@gmail.com", {
		:from => params["email"],
                :from_alias => params["name"],
                :body => params["msg"]
        })
	haml :contact, :locals => {:success => success}
  end

end
