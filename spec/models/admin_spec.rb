#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe Admin do
  let(:admin) { Factory(:admin) }

  describe "validation" do
    describe "of passwords" do
      it "fails if password doesn't match confirmation" do
        user = Factory.build(:admin, :password => "password", :password_confirmation => "nope")
        user.should_not be_valid
      end

      it "succeeds if password matches confirmation" do
        user = Factory.build(:admin, :password => "password", :password_confirmation => "password")
        user.should be_valid
      end
    end

    describe "of username" do
      it "requires presence" do
        user = Factory.build(:admin, :username => nil)
        user.should_not be_valid
      end

      it "requires uniqueness" do
        duplicate_user = Factory.build(:admin, :username => admin.username)
        duplicate_user.should_not be_valid
      end

      it "keeps the original case" do
        user = Factory.build(:admin, :username => "WeIrDcAsE")
        user.should be_valid
        user.username.should == "WeIrDcAsE"
      end

      it "fails if the requested username is only different in case from an existing username" do
        duplicate_user = Factory.build(:admin, :username => admin.username.upcase)
        duplicate_user.should_not be_valid
      end

      
    end

    describe "of email" do
      it "requires email address" do
        user = Factory.build(:admin, :email => nil)
        user.should_not be_valid
      end

      it "requires a unique email address" do
        duplicate_user = Factory.build(:admin, :email => admin.email)
        duplicate_user.should_not be_valid
      end
    end
  end

  describe ".find_for_authentication" do
    it "preserves case" do
      Admin.find_for_authentication(:username => admin.username).should == admin
      Admin.find_for_authentication(:username => admin.username.upcase).should be_nil
    end
  end

end
