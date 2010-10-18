require File.join(File.dirname(__FILE__), "..", "..", "config", "environment")

    admin = Admin.create(:email=> "gaurav@example.com",
                         :username => "gaurav",
                         :password=> "newadmin",
                         :password_confirmation => "newadmin")
    admin.save!