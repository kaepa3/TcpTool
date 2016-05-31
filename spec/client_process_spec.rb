require 'spec_helper'
require 'yaml'
require 'socket'
require_relative '../classes/client_process'
require_relative '../classes/log_module'

Log.info('korena')

TEST_PORT = 62_000

describe 'is Ok?' do
  it 'open and read' do
    server = TCPServer.open(TEST_PORT)
    Thread.new do
      begin
        client = server.accept
        process = ClientProcess.new(client, 'spec/test_dispatcher.yml')
        process.start
      rescue => e
        puts e.message
      end
    end
    buff = nil
    counter = 0
    while counter < 3
      begin
        sock = TCPSocket.open('127.0.0.1', TEST_PORT)
        puts 'send test data'
        sock.write([0, 0, 5, 0].pack('C*'))
        ret = IO.select([sock], nil, nil, 3)
        if ret != nil
          ret[0].each do |obj|
            buff = obj.recv(6000)
          end
          puts buff
          break
        end
        sock.close
      rescue => exception
        puts exception.message + ' ' + counter.to_s
      end
      counter += 1
      sleep 1.0
    end
    expect(buff).not_to eq(nil)
  end
end
