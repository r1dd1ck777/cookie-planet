require "net/http"

class BaseGrabber
  def sleep_delay
    # sleep(0.5)
  end

  def url_exists? path_or_url
    sleep_delay
    net_url = URI.parse(url(path_or_url))
    req = Net::HTTP.new(net_url.host, net_url.port)
    path = "#{net_url.path}?#{net_url.query}"

    res = req.request_head path

    res.code == "200"
  rescue
    return false
  end

  def in_witelist? url
    r = false
    %w(jpg jpeg png bmp).each do |ext|
      return true if url.include? ext
    end

    r
  end

  def valid_image? url
    in_witelist?(url) && url_exists?(url)
  end

  def get_page path_or_url
    abs_url = url(path_or_url)

    filename = url2filename(abs_url)
    if File.exist?(filename)
      puts "cache: #{abs_url}"
      html = open(filename).read
    else
      puts "web: #{abs_url}"
      html = open(abs_url).read
      save_cache filename, html
    end

    url_exists?(abs_url) ? Nokogiri::HTML(html) : nil
  end

  def save_cache filename, html
    File.open(filename, 'w') {|f| f.write(html) }
  end

  def url2filename url
    "#{Rails.root}/grabber_cache/#{Base64.encode64(url).gsub('/', '_')}"

  end

  def url path_or_url
    URI.parse(URI.encode(path_or_url.index('http').present? ? path_or_url : "#{remote_base_url}#{path_or_url}")).to_s
  end

  def remote_base_url
    raise StandardError
  end
end