###
# middleman-casper configuration
###

config[:casper] = {
  blog: {
    url: 'https://calebsylvest.github.io/idea-gen/',
    name: 'Idea Gen',
    description: 'Scratching my head and knocking the ideas out',
    date_format: '%d %B %Y',
    navigation: true,
    logo: nil # Optional
  },
  author: {
    name: 'Caleb Sylvest',
    bio: 'Eat, Sleep, and be Merry', # Optional
    location: 'Dallas, TX', # Optional
    website: 'http://heyspacetime.com/', # Optional
    gravatar_email: 'caleb.sylvest@gmail.com', # Optional
    twitter: 'calebsylvest' # Optional
  },
  navigation: {
    "Home" => "/"
  }
}

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

def get_tags(resource)
  if resource.data.tags.is_a? String
    resource.data.tags.split(',').map(&:strip)
  else
    resource.data.tags
  end
end

def group_lookup(resource, sum)
  results = Array(get_tags(resource)).map(&:to_s).map(&:to_sym)

  results.each do |k|
    sum[k] ||= []
    sum[k] << resource
  end
end

tags = resources
  .select { |resource| resource.data.tags }
  .each_with_object({}, &method(:group_lookup))

tags.each do |tagname, articles|
  proxy "/tag/#{tagname.downcase.to_s.parameterize}/feed.xml", '/feed.xml',
    locals: { tagname: tagname, articles: articles[0..5] }, layout: false
end

proxy "/author/#{config.casper[:author][:name].parameterize}.html",
  '/author.html', ignore: true

# General configuration

###
# Helpers
###

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "articles/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tag/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  # blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

# Pretty URLs - https://middlemanapp.com/advanced/pretty_urls/
activate :directory_indexes

# Middleman-Syntax - https://github.com/middleman/middleman-syntax
set :haml, { ugly: true }
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, footnotes: true,
  link_attributes: { rel: 'nofollow' }, tables: true
activate :syntax, line_numbers: false

# Middleman-Sprockets - https://github.com/middleman/middleman-sprockets
activate :sprockets

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


configure :development do
  # Reload the browser automatically whenever files change
  activate :livereload
end

# Build-specific configuration
configure :build do
  # Minify assets
  activate :minify_html
  activate :minify_css
  activate :minify_javascript

  # Append a hash to asset urls (make sure to use the url helpers)
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Ignoring Files
  ignore 'javascripts/_*'
  ignore 'javascripts/vendor/*'
  ignore 'stylesheets/_*'
  ignore 'stylesheets/vendor/*'
end
