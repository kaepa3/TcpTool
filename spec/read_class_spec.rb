require 'spec_helper'
require_relative '../read_file'
describe 'Dog' do
  it 'is named Pochi' do
    reader = ReadFile.new
    data = reader.read_text('spec/test.txt')
    bar = [0xc8, 0xFF, 0x37, 00]
    expect(data).to eq(bar)
  end
end
