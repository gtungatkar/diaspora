require 'spec_helper'

describe AdminInvitationsController do
  before do
    @admin = Factory.create(:admin)
    sign_in :admin, @admin
    request.env["devise.mapping"] = Devise.mappings[:admin]

  end
 render_views
  describe '#create' do
    it 'create invitations' do
      params = {"admin" => {"email" => "gauravstt@gmail.com", :invite_messages => {:admin=>"hello"}} }
      post("create", params)
      flash[:notice].should == "Your invitation has been sent."
    end
  end
end