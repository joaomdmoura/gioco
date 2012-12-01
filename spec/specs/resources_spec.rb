require 'spec_helper'

describe Gioco::Resources do
  let(:user) { FactoryGirl.create(:user) }
  let(:type) { Type.find_by_name "comments" }
  let(:noob_badge) { Badge.find_by_name "noob" }
  let(:medium_badge) { Badge.find_by_name "medium" }

  context "Get a new resource and add and remove points to it" do

    it "should have nil as value of points" do
      user.points.should == []
    end

    context "Incressing points to an user win noob badge of type comment" do

      it "Add the n00b badge and the points related to an user" do
        Gioco::Resources.change_points( user.id, noob_badge.points, type.id )
        user.reload
        user.badges.should include noob_badge
        user.points.where(:type_id => type.id).sum(:value) == noob_badge.points
      end

    end

    context "Decressing points to an user loose meidum badge" do

      before(:all) do
        Gioco::Resources.change_points( user.id, medium_badge.points, type.id )
      end

      it "Remove the medium badge and the points related" do
        Gioco::Resources.change_points( user.id, - medium_badge.points, type.id )
        user.reload
        user.badges.should_not include medium_badge
        user.points.where(:type_id => type.id).sum(:value) == 0
      end

    end

  end

end