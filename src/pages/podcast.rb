require 'oga'
require 'open-uri'
require 'date'
require 'mustache'

MONTHS = %w[
Janeiro Fevereiro Março Abril
Maio Junho Julho Agosto
Setembro Outubro Novembro Dezembro
]

def fmt_date(date)
  "#{date.strftime("%d")} de #{MONTHS[date.month - 1]} de #{date.year}"
end

def feed
  open("https://rss.simplecast.com/podcasts/1418/rss")
    .read
    .tap { |body| File.write("cache/rss", body) }
rescue
  open("cache/rss")
end

episodes = Oga
  .parse_xml(feed)
  .xpath('rss/channel/item')
  .map do |i|
    published = Date.parse(i.xpath('pubDate')[0].text)

    {
      title: i.xpath('title')[0].text.strip,
      url: i.xpath('link')[0].text.strip,
      description: i.xpath('description')[0].text.strip,
      published: published,
      published_readable: fmt_date(published),
    }
  end

File.write(
  "build/podcast.html",
  Mustache.render(
    File.read("src/pages/podcast.html.mustache"),
    episodes: episodes,
  ),
)
