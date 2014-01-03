require 'spec_helper'

describe "gioco:add_badge" do
  include_context "rake"

  it "Try to add an non-existing badge" do
    expect{subject.invoke('non-existing-badge',100,'comments')}.not_to raise_error
  end

  it "Try to add an already created noob badge" do
    expect{subject.invoke('noob',100,'comments')}.to raise_error
  end

end
