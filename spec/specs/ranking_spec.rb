require 'spec_helper'

describe Gioco::Ranking do
  let(:user_a) { FactoryGirl.create(:user) }
  let(:user_b) { FactoryGirl.create(:user) }
  let(:user_c) { FactoryGirl.create(:user) }
  let(:kind) { Kind.find_by_name "comments" }
  let(:noob_badge) { Badge.find_by_name "noob" }
  let(:medium_badge) { Badge.find_by_name "medium" }
  let(:hard_badge) { Badge.find_by_name "hard" }

  context "Generating a ranking of users" do

    before(:each) do
      User.delete_all
      noob_badge.add(user_a.id)
      hard_badge.add(user_b.id)
      medium_badge.add(user_c.id)
    end

    it "Return the users ordered by their badges and points" do
      Gioco::Ranking.generate.should_not be_nil
      Gioco::Ranking.generate[0][:kind].should == kind
      Gioco::Ranking.generate[0][:ranking].should == [ user_b, user_c, user_a ]
    end

  end

end
