class PetitionMailer < ActionMailer::Base
  default({
    :from => SITE['default_from_email_address'],
    :parts_order => ["text/html", "text/plain", "text/enriched"]
  })

  def petition_signature_confirmation(petition_signature)
    @member = petition_signature.member
    @email = petition_signature.petition.autofire_email

    mail({
      :from => @email.from,
      :to => @member.email,
      :subject => @email.subject
    }) do |format|
      format.html
      format.text
    end
    
  end
end
