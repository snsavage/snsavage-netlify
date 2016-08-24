activate :dotenv

###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  blog.layout = "article_layout"
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  blog.permalink = "blog/{year}/{title}.html"
  # Matcher for blog source files
  blog.sources = "blog/{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
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
    # short_url = bitly(full_url(page.url))
    uri = URI("https://twitter.com/intent/tweet")
    query = {url: full_url(page.url), text: page.title, via: data.social.twitter.via}
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

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# set :partials_dir, 'partials'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

set :markdown_engine, :redcarpet

activate :syntax, :line_numbers => true
set :markdown, :fenced_code_blocks => true, :smartypants => true

activate :google_analytics do |ga|
    ga.tracking_id = 'UA-82742395-1'

    # Tracking in development environment (default = true)
    ga.development = false
end

