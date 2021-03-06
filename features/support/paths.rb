module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the admin dashboard page/
      '/admin'
    when /the admin users page/
      '/admin/admin_users'
    when /the issue ideas index/
      issue_ideas_path(@issue.first)
    when /an issue archive page/
      issue_archive_path(Issue.last)
    when /an issue page/
      issue_path(Issue.first)
    when /the first petition page/
      custom_petition_path(Petition.first.custom_path)
    when /this debate page/
      issue_debate_path(Debate.first.issue_id, Debate.first)
    when /the petition taf page/
      "#{custom_petition_path(Petition.first.custom_path)}#compartilhe"
    when /the personal stories page for an issue/
      issue_personal_stories_path(Issue.first.id)
    when /the personal stories page with a story id in the URL for an issue/
      issue_personal_story_path(Issue.first.id, PersonalStory.last.id)
    when /the about page/
      page_path("sobre_nos")
    when /this member page/
      member_path(@member)
    when /my profile page/
      member_path(ProviderAuthorization.find_by_uid("547955110").member)
    when /the first idea page/
      issue_idea_path(Idea.order(:id).first.issue_id, Idea.order(:id).first.id)
    when /the first issue's ideas page/
      issue_ideas_path(:issue_id => Issue.first.id)
    when /this issue page/
      issue_path(@issue)
    when /this petition page/
      custom_petition_path(@petition.custom_path)
    when /the authentication page for this application/
      Doorkeeper::Engine.routes.url_helpers.authorization_path(:response_type => "code", :client_id => @oauth_app.uid, :redirect_uri => @oauth_app.redirect_uri)
    when /the donation/
      "#doe"
    when /the TAF/
      "#compartilhe"
    when /the sign in page/
      "/members/sign_in"
    when /the forgot my password page/
      new_member_password_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
