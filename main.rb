require 'rubygems'
require 'simple-rss'
require 'faraday'
require 'open-uri'
require 'time'
require 'ap'

keywords = %w[环境保护 自然保护 森林 热带雨林 环境 自然 保护 生命科学 生命 科学 研究 论坛 林 热带 雨林]

def url(keyword)
  u = "https://news.google.com/news/rss/search/section/q/#{keyword}/#{keyword}?hl=zh-CN&gl=CN&ned=cn"
  uri = URI::encode u
  uri
end

def get_link(link)
  # query = URI(link).query
  # CGI::parse(query)["url"][0] if query
  link
end

def in_range(datetime)
  start_time = (Time.now - 7 * 60 * 60 * 24).to_i
  end_time = Time.now.to_i
  (start_time..end_time) === datetime.to_i
end

def print_list(keyword)
  txt = Faraday.get url(keyword)
  rss = SimpleRSS.parse txt.body
  rss.entries.each do |r|
    next if !in_range(r.pubDate)
    link = get_link(r.link)
    puts "#{r.title} ----> #{link}" if link
  end
end

keywords.each do |keyword|
  puts("Search for: " + keyword)
  print_list(keyword)
end
