require 'spec_helper'

describe Gioco::Ranking do
  let(:user_a) { FactoryGirl.create(:user) }
  let(:user_b) { FactoryGirl.create(:user) }
  let(:user_c) { FactoryGirl.create(:user) }
  let(:type) { FactoryGirl.create(:type) }
  let(:noob_badge) { FactoryGirl.create(:badge, :type => type) }
  let(:medium_badge) { FactoryGirl.create(:badge, { :name => "medium", :points => 500, :type => type } ) }
  let(:hard_badge) { FactoryGirl.create(:badge, { :name => "hard", :points => 1000, :type => type } ) }

  context "Generating a ranking of users" do

    before(:all) do
      Type.delete_all
      User.delete_all
      Gioco::Badges.add( user_a.id, noob_badge.id )
      Gioco::Badges.add( user_b.id, hard_badge.id )
      Gioco::Badges.add( user_c.id, medium_badge.id )
    end

    it "Return the users ordered by their badges and points" do
      Gioco::Ranking.generate.should_not be_nil 
      Gioco::Ranking.generate[0][:type].should == type
      Gioco::Ranking.generate[0][:ranking].should == [ user_b, user_c, user_a ]
    end

  end

end