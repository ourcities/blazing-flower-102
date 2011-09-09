require 'spec_helper'

describe Member do
  it { should validate_presence_of :email }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { 
    Factory(:member)
    should validate_uniqueness_of :email
  }

  describe "#debates_side_1" do
    before do 
      @member = Factory(:member)
      @debate = Factory.create(:debate, :author_1 => @member)
    end

    it "should find the debate where the member is author 1" do
      @member.debates_side_1.first.id.should == @debate.id
    end
  end

  describe "#debates_side_2" do
    before do 
      @member = Factory(:member)
      @debate = Factory.create(:debate, :author_2 => @member)
    end

    it "should find the debate where the member is author 1" do
      @member.debates_side_2.first.id.should == @debate.id
    end
  end

  describe ".find_for_facebook_oauth" do
    it "should find the member by email when he's already in the database" do
      m = Factory(:member, :email => FACEBOOK_VALID_AUTH_DATA["extra"]["user_hash"]["email"] )
      Member.find_for_facebook_oauth(FACEBOOK_VALID_AUTH_DATA).should == m
    end

    context "when he's not in the database" do

      it "should create using his email" do
        Member.find_for_facebook_oauth(FACEBOOK_VALID_AUTH_DATA).email.should == FACEBOOK_VALID_AUTH_DATA["user_info"]["email"]
      end

      it "should create using his gravatar" do
        Member.find_for_google_oauth(FACEBOOK_VALID_AUTH_DATA).image_url.should == 'http://www.gravatar.com/avatar/5e2a237dafbc45f79428fdda9c5024b1.jpg?s=260&d=http://localhost:3000/assets/avatar_blank.png'
      end

    end

  end

  describe ".find_for_google_oauth" do
    it "should find the member by email when he's already in the database" do
      m = Factory(:member, :email => GOOGLE_APP_VALID_AUTH_DATA["user_info"]["email"])
      Member.find_for_google_oauth(GOOGLE_APP_VALID_AUTH_DATA).should == m
    end

    context "when he's not in the database and using a google custom domain" do
      let(:auth_data) do 
        GOOGLE_CUSTOM_DOMAIN_VALID_AUTH_DATA['user_info'].merge!({'email' => 'foo@bar.com'})
        GOOGLE_CUSTOM_DOMAIN_VALID_AUTH_DATA
      end
      subject{ Member.find_for_google_oauth(auth_data) }
      its(:email){ should == auth_data['user_info']['email'] }
      its(:first_name){ should == auth_data['user_info']['first_name'] }
      its(:last_name){ should == auth_data['user_info']['last_name'] }
    end

    context "when he's not in the database" do
      it "should create the member using his name and email" do
        Member.find_for_google_oauth(GOOGLE_APP_VALID_AUTH_DATA).email.should == 'ren.provey@gmail.com'
      end

      it "should create using his gravatar" do
        Member.find_for_google_oauth(GOOGLE_APP_VALID_AUTH_DATA).image_url.should == 'http://www.gravatar.com/avatar/e9d7835fee9dabb3745b3bae39d8a1ff.jpg?s=260&d=http://localhost:3000/assets/avatar_blank.png'
      end

    end
  end

  describe "#has_signed?" do
    let(:member){ Factory(:member) }
    subject{ member.has_signed?(1) }
    context "when the user has signed" do
      before do 
        member.stub_chain(:petition_signatures, :find_by_petition_id).with(1).and_return(mock_model(PetitionSignature))
      end
      it{ should be_true }
    end
    context "when the user has not signed" do
      before do 
        member.stub_chain(:petition_signatures, :find_by_petition_id).with(1).and_return(nil)
      end
      it{ should be_false }
    end
  
  end
end
