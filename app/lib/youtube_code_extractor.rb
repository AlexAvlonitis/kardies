class YoutubeCodeExtractor
  AFTER_EQUALS = /([^\=]+)$/
  AFTER_LAST_SLASH = %r{([^\/]+)$}

  def initialize(youtube_url)
    @youtube_url = youtube_url
  end

  def extract
    if youtube_url.include? youtube_url_string
      code = youtube_url[AFTER_EQUALS]
      convert_code_to_embedded_link(code)
    elsif youtube_url.include? youtube_mobile_url_string
      code = youtube_url[AFTER_LAST_SLASH]
      convert_code_to_embedded_link(code)
    else
      convert_code_to_embedded_link(youtube_url)
    end
  end

  private

  attr_reader :youtube_url

  def youtube_url_string
    'youtube.com'
  end

  def youtube_mobile_url_string
    'youtu.be'
  end

  def convert_code_to_embedded_link(code)
    "https://www.youtube.com/embed/#{code}"
  end
end
