require 'spec_helper'

describe IssuesController do
  before do
    @issue = Factory.create(:issue)
  end

  describe "GET show" do
    it "has a 200 status code" do
      get :show, :id => @issue.id
      response.code.should eq("200")
    end
  end

  describe "GET archive" do
    it "has a 200 status code" do
      get :show, :id => @issue.id
      response.code.should eq("200")
    end

    it "assigns @articles without any nil items when only published petitions exist" do
      @published_petition = Factory(:complete_petition, :issue => @issue).tap{ |p| p.publish }

      xhr :get, :archive, :id => @issue.id
      assigns(:articles).should == [@published_petition]
    end

    it "assigns @articles with only published and archived petitions" do
      @draft_petition = Factory(:petition, :issue => @issue)
      @archived_petition  = Factory(:complete_petition, :issue => @issue).tap{ |p| p.publish && p.archive }
      @published_petition = Factory(:complete_petition, :issue => @issue).tap{ |p| p.publish }

      xhr :get, :archive, :id => @issue.id, :format => :js
      assigns(:articles).should == [@published_petition, @archived_petition]
    end
  end
end
