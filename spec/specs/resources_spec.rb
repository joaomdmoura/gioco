require 'spec_helper'

describe Gioco::Resources do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:noob_badge) { FactoryGirl.create(:badge) }
  let(:medium_badge) { FactoryGirl.create(:badge, { :name => "medium", :points => 500 } ) }

  context "Get a new resource and add and remove points to it" do

    it "should have nil as value of points" do
      user.points.should == nil
    end

    context "Adding points to an user win noob badge using resource id" do

      before(:all) do
        Gioco::Resources.change_points( user.id, noob_badge.points )
      end

      it "should add the n00b badge a user" do
        User.last.badges.should include noob_badge
      end

      it "should have the points related to n00b badge" do
        User.last.points.should == noob_badge.points
      end

    end

    context "Adding points to an user win meidum badge using a user object" do

      before(:all) do
        Gioco::Resources.change_points( nil, medium_badge.points, user )
      end

      it "should add the medium badge a user" do
        User.last.badges.should include medium_badge
      end

      it "should have now the points related to n00b badge" do
        User.last.points.should == medium_badge.points
      end

    end

  end

end