require 'spec_helper'

describe "Gioco: seeds support" do
  let(:user_a) { FactoryGirl.create(:user) }
  let(:user_b) { FactoryGirl.create(:user) }
  let(:user_c) { FactoryGirl.create(:user) }

  context "Running seeds to simulating production environment" do

    before(:all) do
      User.delete_all
      Badge.delete_all
      Kind.delete_all
      Point.delete_all
    end

    context "Using rake db:seed to recreate all badges registers and relations" do
    
      before :all do
        `cd #{Rails.root}/; rake db:seed`
      end

      it "All Badges and Kinds should be created" do
        Badge.all.size.should == 3
        Kind.all.size.should  == 1
      end

      it "Kind teacher should not exist" do
        Kind.find_by_name("teacher").should be_nil
      end
    
    end

  end

end