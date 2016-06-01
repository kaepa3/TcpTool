require 'spec_helper'
require 'yaml'
require 'socket'
require_relative '../classes/client_process'
require_relative '../classes/log_module'

describe 'is Ok?' do
  TEST_PORT = 62_000
  server = TCPServer.open(TEST_PORT)

  Thread.new do
    begin
      client = server.accept
      process = ClientProcess.new(client, 'spec/client_process.yml')
      process.start
    rescue => e
      puts e.message
    end
  end
  counter = 0
  sock = nil
  while counter < 3
    begin
      sock = TCPSocket.open('127.0.0.1', TEST_PORT)
      break
    rescue => exception
      puts exception.message + ' ' + counter.to_s
    end
    counter += 1
    sleep 0.5
  end

  violated if sock.nil?
  it 'open and read' do
    buff = nil
    puts "send test data#{sock}"
    sock.write([0, 0, 5, 0].pack('C*'))
    ret = IO.select([sock], nil, nil, 3)
    violated if ret.nil?
    ret[0].each do |obj|
      buff = obj.recv(6000)
    end
    sock.close
    expect(buff[1]).not_to eq(255)
  end
end
