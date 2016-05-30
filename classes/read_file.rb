# reading file
class ReadFile
  # Read text file
  def read_text(file_path)
    common_call('get_text', file_path)
  end

  def read_binaly(file_path)
  end

  def read_csv(file_path)
    common_call('get_csv', file_path)
  end

  def method_missing(call_name, *args)
    puts "method call:#{call_name} args:#{args}"
    false
  end

  private

  def common_call(method_name, file_path)
    binaly = []
    begin
      binaly = send(method_name, file_path)
    rescue
      binaly = false
    end
    binaly
  end

  def get_csv(file_path)
    binaly = []
    File.open(file_path) do |f|
      while (line = f.gets)
        text = line[0, line.index(';')]
        binaly.concat(text.split(',')) if text != 0
      end
    end
    binaly.map!(&:hex)
  end

  def get_text(file_path)
    binaly = []
    File.open(file_path) do |f|
      while (line = f.gets)
        text = line[0, line.index(';')]
        binaly.concat(text.split(' ')) if text != 0
      end
    end
    binaly.map!(&:hex)
  end
end
