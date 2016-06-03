require 'spec_helper'
require_relative '../classes/collect_code'

describe 'collect' do
  collect = CollectCode.new
  it 'normal' do
    expect(collect.collect([0x80, 0, 0, 1], 0, 4)).to eq(0x80000001)
    expect(collect.collect([0x12, 0x34, 0x56, 0x78], 0, 4)).to eq(0x12345678)
  end
  it 'reverse' do
    expect(collect.collect([0x12, 0x34, 0x56, 0x78], 0, 4, false)).to eq(0x78563412)
  end

end
