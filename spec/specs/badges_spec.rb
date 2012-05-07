require 'spec_helper'

describe Gioco::Badges do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:noob_badge) { FactoryGirl.create(:badge) }
  let(:medium_badge) { FactoryGirl.create(:badge, { :name => "medium", :points => 500 } ) }

  describe "Get a new resource and add and remove badges to it" do

    context "Adding a badge to an user using ids" do

      before(:all) do
        Gioco::Badges.add( user.id, noob_badge.id )
      end

      it "should add the n00b badge a user" do
        User.last.badges.should include noob_badge
      end

      it "should have now the points related to n00b badge" do
        User.last.points.should == noob_badge.points
      end

    end

    context "Adding a badge to an user using objects" do

      before(:all) do
        Gioco::Badges.add( nil, nil, user, medium_badge )
      end

      it "should add the n00b badge a user" do
        User.last.badges.should include medium_badge
      end

      it "should have now the points related to n00b badge" do
        User.last.points.should == medium_badge.points
      end

    end

    context "Removing a badge to an user using ids" do

      before(:all) do
        Gioco::Badges.add( user.id, noob_badge.id )
        Gioco::Badges.add( user.id, medium_badge.id )
        Gioco::Badges.remove( user.id, medium_badge.id )
      end

      it "should remove the medium badge a user" do
        User.last.badges.should_not include medium_badge
      end

      it "should have again the points related old n00b badge" do
        User.last.points.should == noob_badge.points
      end

    end

    context "Removing a badge to an user using objects" do

      before(:all) do
        Gioco::Badges.add( nil, nil, user, noob_badge )
        Gioco::Badges.remove( nil, nil, user, noob_badge )
      end

      it "should add the n00b badge a user" do
        User.last.badges.should_not include noob_badge
      end

      it "should have now 0 points cause was the last badge related to the user" do
        User.last.points.should == 0
      end

    end

  end

end