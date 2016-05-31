require 'logger'

module Log
  @logger = Logger.new('app.log', 7, 10 * 1024 * 1024)
  def self.method_missing(call_name, *args)
    if @logger.methods.include?(call_name)
      @logger.send(call_name, *args)
    else
      puts " no method:#{call_name} args:#{args}"
    end
  end
end

module RevLog
  @logger = Logger.new('rev.log', 7, 10 * 1024 * 1024)
  def self.method_missing(call_name, *args)
    if @logger.methods.include?(call_name)
      @logger.send(call_name, *args)
    else
      puts " no method:#{call_name} args:#{args}"
    end
  end
end
