ary = [0x80, 0, 0, 1]

def analyze_code(data, start, len)
  offsets = (0..len).map { |e| 0x100**e }
  begin
    buf = data[start..len]
    buf.each_with_index.inject do |(a, e), i|
      puts "-d #{a} #{e} #{i}"
      a += (e * offsets[i.last])
    end
  end
  0
end

describe 'code analyze' do
  it 'file dispatch' do
    code = analyze_code(ary, 0, 4)
    puts code
    expect(code).to eq(0x80000001)
  end
end
