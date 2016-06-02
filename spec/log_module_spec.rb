require_relative '../classes/log_module'

describe 'log_trace' do
  it 'stack OK?' do
    def second_func
      LogHelper.find_caller(1)
    end
    def first_func
      second_func
    end
    text = first_func
    puts text
    expect(text.any?{ |e| e.include?('first_func') }).to eq(true)
  end
end
describe 'LOGGER' do
  it 'save OK?' do
    Log.info('nanya?')
  end
end

def analyze_code(data, start, len)
  offsets = (0..len).map { |e| 0x100**e }
  begin
    buf = data[start..len]
    buf.each_with_index.inject do |(a, e), i|
      puts "-d #{a} #{e} #{i}"
    end
  end
  0
end

describe 'code analyze' do
  it 'file dispatch' do
    ary = [0, 0, 0, 4]
    code = analyze_code(ary, 0, 4)
    puts code
#    expect(code).to eq(0x80000001)
  end
end
