require 'spec_helper'

describe Gioco::Core do
  let(:user_a) { FactoryGirl.create(:user) }
  
  it "Find the current user by id" do
    Gioco::Core.get_resource(user_a.id).should == user_a
  end

end