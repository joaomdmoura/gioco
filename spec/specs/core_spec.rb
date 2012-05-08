require 'spec_helper'

describe Gioco::Core do
  let(:user_a) { FactoryGirl.create(:user) }
  let(:user_b) { FactoryGirl.create(:user) }
  let(:user_c) { FactoryGirl.create(:user) }
  let(:noob_badge) { FactoryGirl.create(:badge) }
  let(:medium_badge) { FactoryGirl.create(:badge, { :name => "medium", :points => 500 } ) }
  let(:hard_badge) { FactoryGirl.create(:badge, { :name => "hard", :points => 1000 } ) }

  it "Find the current user by id" do
    Gioco::Core.get_resource(user_a.id).should == user_a
  end

  it "Find the current badge by id" do
    Gioco::Core.get_badge(noob_badge.id).should == noob_badge
  end

  context "Generating a ranking of users" do

    before(:all) do
      User.delete_all
      Gioco::Badges.add( user_a.id, noob_badge.id )
      Gioco::Badges.add( user_b.id, hard_badge.id )
      Gioco::Badges.add( user_c.id, medium_badge.id )
    end

    it "Return the users ordered by their badges and points" do
      Gioco::Core.ranking.should_not be_nil 
      Gioco::Core.ranking.should == [ user_b, user_c, user_a ]
    end

  end

end