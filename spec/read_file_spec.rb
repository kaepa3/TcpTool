require 'spec_helper'
require_relative '../classes/read_file'
describe 'Dog' do
  it 'ok text' do
    reader = ReadFile.new
    data = reader.read_text('spec/test_text.txt')
    bar = [0xc8, 0xFF, 0x37, 00]
    expect(data).to eq(bar)
  end
  it 'ok csv' do
    reader = ReadFile.new
    data = reader.read_csv('spec/test_csv.txt')
    bar = [0xc8, 0xFF, 0x37, 03]
    expect(data).to eq(bar)
  end
end
