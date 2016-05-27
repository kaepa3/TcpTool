
tcp_server = TcpServer.new

tcp_server.start(60_000)

loop do
  client = server.accept
  Thread.new(client) do |cl|
    begin
      client_obj = ClientProcess.new(cl)
      client_obj.start
    ensure
      client_obj.close
    end
  end
end
