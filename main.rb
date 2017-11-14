require 'rubygems'
require 'simple-rss'
require 'faraday'
require 'open-uri'
require 'time'

keywords = %w[自然保护 科学研究 科研 技术进展 技术发展 技术 海 海洋 渔业 珊瑚 渔 保护 科学 研发 自然 研究 进展]
# keywords = [
  # "气候领袖",
  # "社区实践营公民科学",
  # "公民生态学",
  # "生态",
  # "环境教育",
  # "自然教育",
  # "可持续发展教育",
  # "地球环境",
  # "环境心理",
  # "自然缺失症",
  # "低碳出行",
  # "自然教育论坛",
  # "世界/国际环境教育峰会",
  # "气候变化",
  # "自然保护污染",
  # "水源保护",
  # "土地",
  # "环保实践",
  # "海洋",
  # "国家公园",
  # "野生动植物",
  # "生态",
  # "植物",
  # "环保报告",
  # "education",
  # "wwf",
  # "nature",
  # "earth",
  # "biodiversity",
  # "IUCN",
  # "UNDP"
# ]

def url(keyword)
  URI::encode "https://news.google.com/news/?q=#{keyword}&output=rss"
end

def get_link(link)
  CGI::parse(URI(link).query)["url"][0]
end

def in_range(datetime)
  (1483200000..1509274904) === datetime.to_i
end

def print_list(keyword)
  txt = Faraday.get url(keyword)
  rss = SimpleRSS.parse txt.body
  rss.entries.each do |r|
    next if !in_range(r.pubDate)
    puts "#{r.title} ----> #{get_link(r.link)}"
  end
end

keywords.each do |keyword|
  puts("Search for: " + keyword)
  print_list(keyword)
end
