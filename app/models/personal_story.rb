class PersonalStory < ActiveRecord::Base
  before_save :get_video_data

  belongs_to :issue

  validates_presence_of :issue
  validates_presence_of :title
  validates_presence_of :video_url
  validates_presence_of :excerpt
  validates_presence_of :description

  validates_format_of :video_url, :with => /\Ahttps?:\/\/(\w+\.?)\w+\.\w{2,3}\/\S+/

  validates_inclusion_of :connected_action, :in => ['PETITION', 'DEBATE', 'NONE'], :allow_nil => true

  default_scope :order => "created_at DESC"

  def get_video_data
    url = URI(self.video_url)
    url = case url.host
    when /vimeo\.com/
      response = HTTParty.get("http://vimeo.com/api/oembed.json?url=#{url}&width=570&height=320&title=false&byline=false&portrait=false")
      if parsed_response = response.parsed_response
        self.video_embed_code = response["html"]
        self.thumbnail = response["thumbnail_url"]
      end
    when /youtube\.com/
      id = Hash[url.query.split("&").map { |p| p.split("=")  }]["v"]
      self.video_embed_code = "<iframe class='youtube-player' type='text/html' width='570' height='320' src='http://www.youtube.com/embed/#{id}?wmode=Opaque' frameborder='0'></iframe>"
      self.thumbnail = "http://img.youtube.com/vi/#{id}/0.jpg"

    when /videolog\.tv/
      id = Hash[url.query.split("&").map { |p| p.split("=") }]['id']
      self.video_embed_code = "<iframe class='youtube-player' type='text/html' width='570' height='320' src='http://embed.videolog.tv/v/index.php?id_video=#{id}&width=570&height=320&swf=1' frameborder='0'></iframe>"
      self.thumbnail = "http://videolog.tv/video_thumb.php?video=#{id}"
      self.video_url = "http://embed.videolog.tv/v/index.php?id_video=#{id}&swf=1"
    end
  end

end
