require 'sinatra'
require 'pry'
require 'csv'

get '/comments.html' do
  erb :comments
end

get '/' do
  @articles_to_display =[]
  # "Hellow, world!"
  CSV.foreach("articles.csv", headers: true, header_converters: :symbol) do |row|
    @articles_to_display.unshift(row.to_hash)
    # binding.pry
    # the problem is that articles.csv is not saving as an array, but rather a list like firebase, firebase.com, description
    # we need to make this save as an array
  end
  # @tasks = File.readlines('tasks')
  erb :index
end

post '/new_article' do
  # binding.pry
  article_for_csv = []
  article_for_csv = [params["title"], params["url"], params["description"]]
  CSV.open('articles.csv', 'a') do |file|
    file.puts(article_for_csv)
  end
  # binding.pry
  # Read the input from the form the user filled out
  # @tasks = params['task_name']

  # Open the "tasks" file and append the task
  #File.open('tasks', 'a') do |file|
   # file.puts(task)
  # end

  # Send the user back to the home page which shows
  # the list of tasks
  redirect '/'

  erb :index
end



set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
