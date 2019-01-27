require 'rubygems'
require 'simple-rss'
require 'faraday'
require 'faraday_middleware'
require 'open-uri'
require 'time'
require 'ap'

keywords = '气候 变化 低碳 新能源 CSR 环保 环境 领域 研究 数据监测 联盟 论坛 绿色 生态 政策 可持续 南极 北极 天气 动物 盗猎'.split(' ')

def url(keyword)
  # u = "https://news.google.com/news/rss/search/section/q/#{keyword}/#{keyword}?hl=zh-CN&gl=CN&ned=cn"
  u = "https://news.google.com/_/rss/search?q=#{keyword}&hl=zh-CN&gl=CN&ceid=CN:zh-Hans"
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
  conn = Faraday.new(url(keyword)) { |b|
    b.use FaradayMiddleware::FollowRedirects
    b.adapter :net_http
  }
  txt = conn.get 
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
