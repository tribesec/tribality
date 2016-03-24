require 'rubygems'
require 'daemons'
 
pwd = Dir.pwd
Daemons.run_proc('tribality_daemon.rb', {:dir_mode => :normal, :dir => "/var/run/"}) do
	Dir.chdir(pwd)
	exec "sudo rackup -D"
end
