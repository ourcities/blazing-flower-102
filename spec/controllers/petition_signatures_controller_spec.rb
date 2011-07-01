require 'spec_helper'

describe PetitionSignaturesController do
  describe "post to Create" do
    before do
      @petition = Factory.create(:complete_petition)
    end
    
    context "New member" do
      before do
        post 'create', {:petition => {:custom_path => @petition.custom_path}, :member => {:email => "test-user@example.org", :name => "Mickey Mouse", :zona => "Centro" }, :petition_signature => {:comment => "test comment"}}
      end
      it "should create a new Member and new Petition Signature" do
        response.should redirect_to custom_taf_path(@petition.custom_path)
        Member.last.email.should == "test-user@example.org"
        PetitionSignature.last.member.should == Member.last
      end

      it "should save the signature comment" do
        PetitionSignature.last.comment.should == 'test comment'
      end
    end

    context "Existing member, new petition" do
      before do
        @member = Factory.create(:member)
        post 'create', {:petition => {:custom_path => @petition.custom_path}, :member => {:email => @member.email, :name => @member.name, :zona => @member.zona }, :petition_signature => {:comment => "test comment"}}
      end

      it "should create a new Petition Signature" do
        response.should redirect_to custom_taf_path(@petition.custom_path)
        Member.count.should == 1
        PetitionSignature.last.member.should == @member
      end

      it "should save the signature comment" do
        PetitionSignature.last.comment.should == 'test comment'
      end
    end

    context "Existing member, exisiting petition signature" do
      before do
        @member = Factory.create(:member)
        PetitionSignature.create({:member_id => @member.id, :petition_id => @petition.id})
      end

      it "should redirect the user to the TAF page without creating any database records" do
        post 'create', {:petition => {:custom_path => @petition.custom_path}, :member => {:email => @member.email, :name => @member.name, :zona => @member.zona }, :petition_signature => {:comment => ""}}
        response.should redirect_to custom_taf_path(@petition.custom_path)
        Member.count.should == 1
        PetitionSignature.count.should == 1
      end
    end
  end
end