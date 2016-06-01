require 'json'
require_relative 'file_dispatcher'

class ClientProcess
  def initialize(socket, file_path)
    @socket = socket
    puts "#{self.class.name} load file #{file_path}"
    @yml_data = YAML.load_file(file_path)
    @file_reader = FileDispatcher.new(@yml_data["file_loder_path"])
    @sendque = Queue.new
    @flg = true
  end

  def start
    Thread.new do
      begin
        process
      rescue => e
        @flg = false
        puts "ソケット終了:" + e.message
      end
    end
  end

  def process
    Thread.new { console_process }
    Thread.new { send_process }
    Thread.new { revieve_process }
  end

  def revieve_process
    while @flg
      ret = IO.select([@socket], nil, nil, 1)
      next if ret.nil?
      ret[0].each do |obj|
        rev = obj.recv(6000)
        next if rev.empty?
        bin = rev.unpack('C*')
        puts bin.map { |b| "0x%02X" % b }.join(' ')
        val = @file_reader.dispatch(bin)
        next if val == false
        @sendque.push val
        puts 'add que!!!'
      end
    end
  end

  def console_process
    while @flg
      cmd = gets.chomp
      exit if cmd == 'e'
      val = @file_reader.dispatch(cmd)
      next if val == false
      @sendque.push val
    end
  end

  def send_process
    while @flg
      if @sendque.length <= 0
        req = @sendque.pop
        next if req.empty?
        puts 'you writed:' + req.map { |b| format('0x%02X', b) }.join(' ')
        @socket.write(req)
      end
    end
  end
end
