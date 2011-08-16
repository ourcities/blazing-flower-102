ActiveAdmin.register LegislativeAgendaWidget do
  menu :parent => "Widgets"
  filter :html_content

  index do
    column :html_content
    column "Options" do |w|
      span link_to 'Show', admin_public_hearings_widget_path(w)
      span link_to 'Edit', edit_admin_public_hearings_widget_path(w)
    end
  end

  form :partial => "form"
end
