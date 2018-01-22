require 'rubygems'
require 'simple-rss'
require 'faraday'
require 'open-uri'
require 'time'

keywords = %w[自然保护方法 自然 保护 方法 方案 案例 成果 创新 野生动物贸易 贸易 野生 动物 查 青少年 绿色 行动 热带雨林 雨林 热带 海洋 渔业 珊瑚]

def url(keyword)
  URI::encode "https://news.google.com/news/?q=#{keyword}&output=rss"
end

def get_link(link)
  query = URI(link).query
  return "" if query.nil?
  url = CGI::parse(query)["url"]
  url.fetch(0, "")
end

def in_range(datetime)
  end_time = Time.now.to_i
  start_time = Time.now.to_i - (86400 * 8)
  (start_time..end_time) === datetime.to_i
end

def print_list(keyword)
  txt = Faraday.get url(keyword)
  rss = SimpleRSS.parse txt.body
  rss.entries.each do |r|
    next if !in_range(r.pubDate)
    link = get_link(r.link)
    next if link.to_s.empty?
    puts "#{r.title} ----> #{link}"
  end
end

keywords.each do |keyword|
  puts("Search for: " + keyword)
  print_list(keyword)
end
