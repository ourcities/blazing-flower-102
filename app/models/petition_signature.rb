class PetitionSignature < ActiveRecord::Base
  belongs_to :petition
  belongs_to :member

  after_create :send_confirmation
  after_create :share_on_facebook
  validate :belongs_to_published_petition
  validates_uniqueness_of :member_id, :scope => :petition_id
  
  scope :by_updated_at, proc { |updated_at| where("petition_signatures.updated_at >= ?", updated_at) }

  def self.unmoderated
    where('comment_accepted IS NULL')
  end

  def self.moderated
    where('comment_accepted IS NOT NULL')
  end

  def send_confirmation
    PetitionMailer.delay.petition_signature_confirmation(self)
  end

  def belongs_to_published_petition
    errors.add(:petition, "Petition must be published in order to be signed") unless petition.published?
  end

  def reject_comment
    self.update_attribute :comment_accepted, false
    self
  end

  def accept_comment
    self.update_attribute :comment_accepted, true
    self
  end

  def share_on_facebook
    if self.member.facebook_authorization
      graph = Koala::Facebook::GraphAPI.new(self.member.facebook_authorization.token)
      graph.delay.put_connections("me", "feed", :link => Rails.application.routes.url_helpers.custom_petition_url(:custom_path => self.petition.custom_path))
    end
  end
end
