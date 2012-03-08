Given /^I am logged in$/ do
  @member = Factory.create(:member, :password => "clever_password", :password_confirmation => "clever_password", :confirmed_at => Time.now)
  #visit "/"
  #click_link "Entrar"
  #click_link "Entre com sua conta do Meu Rio"
  #fill_in "E-mail", :with => @member.email
  #fill_in "Senha", :with => "clever_password"
  #click_button "Entrar"
end

Given /^I am logged in via Facebook$/ do
  visit "/members/auth/facebook"
  @member = Member.find_by_email("diogob@gmail.com")
end

Given /^there is an issue$/ do
  @issue = Factory.create(:issue)
end

Given /^there is an issue with letters enabled$/ do
  @issue = Factory.create(:issue, :letters_enabled => true)
end

Given /^there is a petition called "([^"]*)"$/ do |arg1|
  @petition = Factory.create(:complete_petition, :title => arg1)
  @petition.publish
end

Given /^I already signed this petition$/ do
  Factory.create(:petition_signature, :member => @member, :petition => @petition)
end

Given /^I have a friend called "([^"]*)"$/ do |arg1|
  Koala::Facebook::GraphAPI.any_instance.stub(:get_connections).with("me", "friends").and_return([{"name"=>arg1, "id"=>"2630"}])
end


Given /^there is an OAuth application called "([^"]*)"$/ do |arg1|
  @oauth_app = Doorkeeper::Application.create :name => arg1, :redirect_uri => "http://locahost:3001"
end

Then /^I should see a link to (.+)$/ do |path|
  page.should have_css("a[href=\"#{path_to(path)}\"]")
end
