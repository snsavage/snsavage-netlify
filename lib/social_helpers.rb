require 'net/http'

module SocialHelpers
  def full_url(path)
    if build?
      server = data.social.url.production
    else
      server = data.social.url.development
    end
    URI.join(server, path)
  end

  def bitly(url)
    uri = URI('https://api-ssl.bitly.com')
    uri.path = '/v3/shorten/'
    uri.query = URI.encode_www_form(access_token: ENV['BITLY'], 
                                    longUrl: url, 
                                    format: 'txt')
    Net::HTTP.get(uri)
  end

  def twitter(page)
    short_url = bitly(full_url(page.url))
    uri = URI("https://twitter.com/intent/tweet")
    # query = {text: page.title + " " + short_url, via: data.social.twitter.via}
    query = {text: page.title + " " + full_url(page.url).to_s, via: data.social.twitter.via}
    uri.query = query.to_query
    uri
  end

  def facebook(page)
    uri = URI("https://www.facebook.com/sharer.php")
    query = {u: full_url(page.url)}
    uri.query = query.to_query
    uri
  end

  def google(page)
    uri = URI("https://plus.google.com/share")
    query = {url: full_url(page.url)}
    uri.query = query.to_query
    uri
  end

  def linkedin(page)
    uri = URI("https://www.linkedin.com/shareArticle")
    query = {url: full_url(page.url), title: page.title}
    uri.query = query.to_query
    uri
  end
end
