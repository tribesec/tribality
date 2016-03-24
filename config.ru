#\ -p 80 -o 0.0.0.0
# config.ru
require './app'
set :port, 80
run HelloWorldApp
