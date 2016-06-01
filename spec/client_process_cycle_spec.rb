require 'spec_helper'
require 'yaml'
require 'socket'
require_relative '../classes/client_process'
require_relative '../classes/log_module'

describe 'is Ok?' do
  TEST_PORT = 62_001
  server = TCPServer.open(TEST_PORT)

  Thread.new do
    begin
      client = server.accept
      process = ClientProcess.new(client, 'spec/client_process_cycle.yml')
      process.start
    rescue => e
      puts e.message
    end
  end

  sock = TCPSocket.open('127.0.0.1', TEST_PORT)
  it 'open and read' do
    buff = nil
    ret = IO.select([sock], nil, nil, 3)
    violated if ret.nil?
    ret[0].each { |obj| buff = obj.recv(6000) }
    sock.close
    expect(buff[2]).not_to eq(0x37)
  end
end
