require 'json'
require_relative 'file_dispatcher'

# client spcket class
class ClientProcess
  def initialize(socket, file_path)
    file_path ||= ''
    @socket = socket
    @sendque = Queue.new
    @flg = true
    puts "#{self.class.name} load file #{file_path}"
    @yml_data = YAML.load_file(file_path)
    @counter = Array.new(@yml_data['cycle_files'].length, 0)
    @file_reader = FileDispatcher.new(@yml_data['file_loder_path'])
  end

  def start
    Thread.new { exeption_proc(method(:console_process)) }
    Thread.new { exeption_proc(method(:send_process)) }
    Thread.new { exeption_proc(method(:cycle_process)) }
    exeption_proc(method(:revieve_process))
  end

  def exeption_proc(process)
    while @flg do process.call end
  rescue => e
    puts "error ->#{e.message}"
    @flg = false
  end

  def revieve_process
    ret = IO.select([@socket], nil, nil, 1)
    return if ret.nil?
    ret[0].each do |obj|
      rev = obj.recv(6000)
      break if rev.empty?
      bin = rev.unpack('C*')
      puts bin.map { |b| format('0x%02X', b) }.join(' ')
      val = @file_reader.dispatch(bin)
      @sendque.push val unless val == false
    end
  end

  def cycle_process
    return if @yml_data['cycle_files'].empty?
    @yml_data['cycle_files'].each_with_index do |rec, idx|
      if @counter[idx] >= rec['time']
        val = @file_reader.read(rec['path'], rec['process'])
        return if val == false
        @sendque.push val
      end
      @counter[idx] += 1
    end
    sleep 1
  end

  def console_process
    cmd = STDIN.gets.chomp
    raise if cmd == 'e'
    val = @file_reader.dispatch(cmd)
    return if val == false
    @sendque.push val
  end

  def send_process
    return if @sendque.length <= 0
    req = @sendque.pop
    return if req.empty?
    puts 'you writed:' + req.map { |b| format('0x%02X', b) }.join(' ')
    @socket.write(req)
  end
end
