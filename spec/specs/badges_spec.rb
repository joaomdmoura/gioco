require 'spec_helper'

describe Gioco::Badges do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:noob_badge) { FactoryGirl.create(:badge) }
  let(:medium_badge) { FactoryGirl.create(:badge, { :name => "medium", :points => 500 } ) }

  describe "Get a new resource and add and remove badges to it" do

    context "Adding a badge to an user" do

      it "Add the n00b badge and the points related to an user" do
        Gioco::Badges.add( user.id, noob_badge.id )
        user.reload
        user.badges.should include noob_badge
        user.points.should == noob_badge.points
      end

    end

    context "Removing a badge to an user" do

      before(:all) do
        Gioco::Badges.add( user.id, noob_badge.id )
        Gioco::Badges.add( user.id, medium_badge.id )        
      end

      it "Remove the medium badge and the points related" do
        Gioco::Badges.remove( user.id, medium_badge.id )
        user.reload
        user.badges.should_not include medium_badge
        user.points.should == noob_badge.points
      end

    end

  end

end