class Article
  attr_reader :title, :url, :description, :errors

  def initialize(article = {})
    @title = article["title"]
    @url = article["url"]
    @description = article["description"]
    @errors = []
  end

  def self.all
    raw_article_list = []
    # binding.pry
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

  def valid?

    if @title == "" || @url == "" || @description == ""
      @errors << "Please completely fill out form"
      false
    end

    if @url != "" && @url.include?("http") == false
      @errors << "Invalid URL"
    end

    article_list = Article.all
    if article_list.any? { |article| article.url == @url } == true
      @errors << "Article with same url already submitted"
    end

    if @description != "" && @description.length < 20
      @errors << "Description must be at least 20 characters long"
    end

    @errors.empty?
  end

  def save
    if valid?
      db_connection do |conn|
        conn.exec_params("INSERT INTO articles (title, url, description)
          VALUES ($1, $2, $3);",
          [@title, @url, @description])
      end
      true
    else
      false
    end
  end

end
