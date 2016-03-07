require "sinatra"
require "pg"
require 'pry'
require_relative "./app/models/article"

set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "news_aggregator_development" }
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
  @articles = File.readlines('article.csv')
  erb :articles
end

get '/articles/new' do
  erb :new_article
end

post '/articles' do
  article = [params[:article_title], params[:article_url], params[:article_description]]

  CSV.open(ARTICLE_FILE, 'a') do |file|
    file << article
  end
  
  add_article(params)
  redirect '/articles'
end
