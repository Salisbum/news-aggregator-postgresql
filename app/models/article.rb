class Article
  attr_reader :title, :url, :description

  def initialize(article = {})
    @title = article["title"]
    @url = article["url"]
    @description = article["description"]
  end

  def self.all
    raw_article_list = []

    db_connection do |conn|
      raw_article_list = conn.exec("SELECT * FROM articles;")
    end

    article_instances = []

    raw_article_list.each do |article|
      article_instances << Article.new({"id" => "#{article["id"]}",
      "title" => "#{article["title"]}",
      "url" => "#{article["url"]}",
      "description" => "#{article["description"]}"
      })
    end

    article_instances
  end

end
