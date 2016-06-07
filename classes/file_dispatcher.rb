require 'json'
require_relative 'read_file'
require_relative 'log_module'
require_relative 'collect_code'

class FileDispatcher
  def initialize(file_path)
    Log.info "#{self.class.name} load file #{file_path}"
    begin
      @yml_data = YAML.load_file(file_path)
    rescue => e
      Log.info e.message + self.class.name
    end
  end

  def dispatch(data)
    return if @yml_data.empty?
    colle = CollectCode.new
    judge = colle.collect(data, @yml_data['index'].to_i, @yml_data['len'].to_i)
    records = @yml_data['dispatch'].select { |e| e['code'].to_i == judge }
    return false if records.empty? || !File.exist?(records.first['path'])
    rec = records.first
    obj = ReadFile.new
    Log.info "call #{rec['process']}:#{rec['path']} "
    obj.send(rec['process'], rec['path'])
  end

  def read(path, process)
    obj = ReadFile.new
    Log.info "call #{process}:#{path} "
    obj.send(process, path)
  end
end
