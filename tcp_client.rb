require 'socket'
require_relative 'classes/client_process'

if ARGV.length <= 2
  puts 'There are not enough arguments!!!'
  exit
end

ip_address = ARGV[0]
port = ARGV[1].to_i
config_path = ARGV[2]

loop do

    sock = TCPSocket.open(ip_address, port)
    client_obj = ClientProcess.new(sock, config_path)
    client_obj.start
    while client_obj.flg do sleep 1 end
    puts 'end socket'
  end
