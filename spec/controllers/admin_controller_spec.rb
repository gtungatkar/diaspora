
require 'spec_helper'

describe AdminController do
  before do
    @admin = Factory.create(:admin)
    sign_in :admin, @admin

  end

   describe '#update_signups' do
  #  context 'with a profile photo set' do
   #   before do
   #     @user.person.profile.image_url = "http://tom.joindiaspora.com/images/user/tom.jpg"
   #     @user.person.profile.save
   #   end

      it "opens registration if it is closed" do
        #image_url = @user.person.profile.image_url
        put("update_signups", "reg"=>"open")
        #AdminSettings.reg_open?.should == true
        flash[:notice].should == "signups are opened now"
      end
     it "closes registration if it is open" do
        #image_url = @user.person.profile.image_url
        put("update_signups", "reg"=>"close")
        flash[:notice].should == "signups are closed"
      #  AdminSettings.reg_open?.should == false
      end
    end


  end


