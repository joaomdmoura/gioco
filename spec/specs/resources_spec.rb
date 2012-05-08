require 'spec_helper'

describe Gioco::Resources do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:noob_badge) { FactoryGirl.create(:badge) }
  let(:medium_badge) { FactoryGirl.create(:badge, { :name => "medium", :points => 500 } ) }

  context "Get a new resource and add and remove points to it" do

    it "should have nil as value of points" do
      user.points.should == nil
    end

    context "Incressing points to an user win noob badge" do

      it "Add the n00b badge and the points related to an user" do
        Gioco::Resources.change_points( user.id, noob_badge.points )
        user.reload
        user.badges.should include noob_badge
        user.points.should == noob_badge.points
      end

    end

    context "Decressing points to an user loose meidum badge" do

      before(:all) do
        Gioco::Resources.change_points( user.id, medium_badge.points )
      end

      it "Remove the medium badge and the points related" do
        Gioco::Resources.change_points( user.id, -medium_badge.points )
        user.reload
        user.badges.should_not include medium_badge
        user.points.should == 0
      end

    end

  end

end