require 'redis'
require 'sinatra'
require 'pry'
require 'csv'
require 'json'

def get_connection
  if ENV.has_key?("REDISCLOUD_URL")
    Redis.new(url: ENV["REDISCLOUD_URL"])
  else
    Redis.new
  end
end

def find_articles
  redis = get_connection
  serialized_articles = redis.lrange("slacker:articles", 0, -1)
  articles = []
  serialized_articles.each do |article|
    articles << JSON.parse(article, symbolize_names: true)
  end
  articles
end

def save_article(url, title, description)
  article = { url: url, title: title, description: description }
  redis = get_connection
  redis.rpush("slacker:articles", article.to_json)
end

get '/comments.html' do
  erb :comments
end

get '/' do
  @articles_to_display =[]
  CSV.foreach("articles.csv", headers: true, header_converters: :symbol) do |row|
    @articles_to_display.unshift(row.to_hash)
  end
  erb :index
end

post '/new_article' do
  article_for_csv = []
  article_for_csv = [params["title"], params["url"], params["description"]]
  CSV.open('articles.csv', 'a') do |file|
    file.puts(article_for_csv)
  end
  redirect '/'

  erb :index
end



set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
