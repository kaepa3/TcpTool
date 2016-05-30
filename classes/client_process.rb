require 'json'   
    
class ClientProcess
  def initialize(socket, file_path)
    @socket = socket
    @file_reader = FileDispatcher.new(file_path)
    @sendque = Queue.new
  end

  def start
    Thread.new do 
      begin
        process
      rescue => exception
        puts "ソケット終了:" + exception.message
      end
    end
  end
  
  def process
    Thread.new { console_process }
    loop do
      rev,buff = @socket.recvfrom(100)
      val = @file_reader.dispatch(rev)
    end
  end
  
  def console_process
   loop do
     cmd = gets.chomp
     exit if(cmd == e)
     val = @file_reader.dispatch(cmd)
     next if val == false
     @sendque.enq val
   end
  end
end
