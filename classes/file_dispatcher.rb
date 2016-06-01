require 'json'
require_relative 'read_file'

class FileDispatcher
  def initialize(file_path)
    puts "#{self.class.name} load file #{file_path}"
    @yml_data = YAML.load_file(file_path)
  end

  def dispatch(data)
    judge = data[@yml_data['index'].to_i]
    records = @yml_data['dispatch'].select { |e| e['code'].to_i == judge }
    return false if records.empty? || !File.exist?(records.first['path'])
    rec = records.first
    obj = ReadFile.new
    puts "call #{rec['process']}:#{rec['path']} "
    obj.send(rec['process'], rec['path'])
  end
end
