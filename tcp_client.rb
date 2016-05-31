require 'socket'

if ARGV.length <= 2
  puts 'There are not enough arguments!!!'
  exit
end

ip_address = ARGV[0]
port = ARGV[1].to_i
config_path = ARGV[2]

loop do
  begin
    sock = TCPSocket.open(ip_address, port)
    client_obj = ClientProcess.new(sock, config_path)
    client_obj.start
    while client_obj.flg do sleep 1 end
    puts 'end socket'
  rescue => e
    puts 'exeption' + e.message
  end
end
