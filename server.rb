require 'sinatra'
require 'pry'
require 'csv'

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
