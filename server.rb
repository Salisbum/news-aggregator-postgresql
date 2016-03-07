require "sinatra"
require "pg"
require 'pry'
require_relative "./app/models/article"

set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "news_aggregator_development" }
  # set :db_config, { dbname: "megsalisbury" }
end

configure :test do
  set :db_config, { dbname: "news_aggregator_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

get '/' do
  erb :index
end

get '/articles' do
  # binding.pry
  @articles = Article.all

  erb :articles
end

get '/articles/new' do
  erb :new_article
end

post '/articles' do
  article = Article.new("title" => params[:article_title], "url" => params[:article_url], "description" => params[:article_description])

  article.save

  redirect '/articles'
end
