require 'spec_helper'
require 'kaminari/surface'

describe Kaminari::Surface do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end
