require 'json'
require_relative 'file_dispatcher'

# client spcket class
class ClientProcess
  def initialize(socket, file_path)
    @socket = socket
    @file_reader = FileDispatcher.new(file_path)
    @sendque = Queue.new
    @flg = true
  end

  def start
    Thread.new { exeption_proc(method(:console_process)) }
    Thread.new { exeption_proc(method(:send_process)) }
    exeption_proc(method(:revieve_process))
  end

  def exeption_proc(process)
    process.call
  rescue => e
    puts "error ->#{e.message}"
    @flg = false
  end

  def revieve_process
    while @flg
      ret = IO.select([@socket], nil, nil, 1)
      next if ret.nil?
      ret[0].each do |obj|
        rev = obj.recv(6000)
        next if rev.empty?
        bin = rev.unpack('C*')
        puts bin.map { |b| format('0x%02X', b) }.join(' ')
        val = @file_reader.dispatch(bin)
        @sendque.push val unless val == false
      end
    end
  end

  def console_process
    while @flg
      cmd = STDIN.gets.chomp
      raise if cmd == 'e'
      val = @file_reader.dispatch(cmd)
      next if val == false
      @sendque.push val
    end
  end

  def send_process
    while @flg
      next if @sendque.length <= 0
      req = @sendque.pop
      next if req.empty?
      puts 'you writed:' + req.map { |b| format('0x%02X', b) }.join(' ')
      @socket.write(req)
    end
  end
end
