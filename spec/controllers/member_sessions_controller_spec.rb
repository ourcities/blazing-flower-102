require 'spec_helper'

describe MemberSessionsController do
  include Devise::TestHelpers

  before do
    request.env["devise.mapping"] = Devise.mappings[:member]
  end

  describe "#logout_google" do
    before do
      session[:google_login] = true
      get :google_logout
    end
    it{ should redirect_to( destroy_member_session_path ) }
  end

  describe "#logout_facebook" do
    before do
      session[:fb_token] = "api_key|session_key"
      get :facebook_logout
    end
    it{ should redirect_to( destroy_member_session_path ) }
  end

  describe "#destroy" do
    before do
      sign_in Factory(:member)
      session[:fb_token] = "api_key|session_key"
      session[:google_login] = true
      get :destroy
    end
    it{ session[:fb_token].should be_nil }
    it{ session[:google_login].should be_nil }
  end

  describe "GET new" do
    before { get :new }
    it { should respond_with(:success) }
  end
end
