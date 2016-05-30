require 'spec_helper'
require 'yaml'
require_relative '../classes/client_process'
require "socket"


TEST_PORT = 62_000

describe 'is Ok?' do
  it 'open and read' do
    server = TCPServer.open("127.0.0.1", TEST_PORT)
    Thread.new  do
      client = server.accept
      process = ClientProcess.new(client, 'spec/test_dispatcher.yml')
      process.start
    end
    sock = nil
    counter = 0
    loop do 
      begin
        sock = TCPSocket.open('localhost', TEST_PORT)      
      rescue => exception
        puts exception.message + " " + counter.to_s
        counter += 1
        violated if counter > 10
        sleep 1.0
      end
    end 
    sock.write([0,0,5,0])
    rev, buff = sock.recvfrom(100)
    puts buff
    expect(text.length).to not_eq(0)
    break

  end
end
