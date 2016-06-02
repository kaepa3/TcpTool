require 'logger'

module LogHelper
  def self.find_caller(index)
    return '' if caller.length < index
    texts = caller[index].chomp.split(' ')
    file_pos = correct_filepos(texts.first)
    method_name = texts.last.delete("'").delete('`')
    ['file:' + file_pos, 'method:' + method_name]
  end

  def self.correct_filepos(text)
    find_idx = text.rindex('/') + 1
    text[find_idx, text.length - find_idx - 3]
  end
end

module Log
  include LogHelper
  @logger = Logger.new('app.log', 7, 10 * 1024 * 1024)
  @logger.formatter = proc do |severity, datetime, progname, msg|
    "lvl:#{severity}\ttime:#{datetime}\t#{msg}\n"
  end
  def self.method_missing(call_name, *args)
    if @logger.methods.include?(call_name) && args.length == 1
      buffer = args.first
      ele = [LogHelper.find_caller(2).join("\t")]
      ele << 'msg:' + buffer
      text = ele.join("\t")
      @logger.send(call_name, text)
      puts text
    else
      puts " no method:#{call_name} args:#{args}"
    end
  end
end

module RevLog
  include LogHelper
  @logger = Logger.new('rev.log', 7, 10 * 1024 * 1024)
  def self.method_missing(call_name, *args)
    if @logger.methods.include?(call_name)
      @logger.send(call_name, *args)
    else
      puts " no method:#{call_name} args:#{args}"
    end
  end
end
