require 'spec_helper'
require 'yaml'
require_relative '../classes/file_dispatcher'

describe 'is Ok?' do
  it 'file dispatch' do
    puts Dir.pwd
    disp = FileDispatcher.new('spec/test_dispatcher.yml')
    binalys = [0, 3, 5, 3]
    data = disp.dispatch(binalys)
    bar = [0xc8, 0xFF, 0x37, 00]
    expect(data).to eq(bar)
  end
end
