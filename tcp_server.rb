require 'socket'

if ARGV.length <= 2
  puts 'There are not enough arguments!!!'
  exit
end

ip_address = ARGV[0]
port = ARGV[1].to_i
config_path = ARGV[2]

server = TCPServer.open(ip_address, port)

loop do
  client = server.accept
  Thread.new(client) do |cl|
    begin
      client_obj = ClientProcess.new(cl, config_path)
      client_obj.start
    ensure
      client_obj.close
    end
  end
end
