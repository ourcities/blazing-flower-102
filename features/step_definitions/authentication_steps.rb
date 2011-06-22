When /^I fill in the admin login form$/ do
  fill_in 'user_email', :with => User.first.email
  fill_in 'user_password', :with => '123-test'
end

Given /^there is one deactivated user$/ do
  Factory.create(:deactivated)
end

Given /^I change my password$/ do
  click_link "Edit registration"
  fill_in 'user_password', :with => "very_safe"
  fill_in 'user_password_confirmation', :with => "very_safe"
  click_button 'Update'
end

When /^I fill in the admin login form with my new password$/ do
  fill_in 'user_email', :with => User.first.email
  fill_in 'user_password', :with => 'very_safe'
end
