class ArticleDatatable < AjaxDatatablesRails::Base

  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to ,:can?, :articles_path, :article_path, :edit_article_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['articles.name','articles.duration']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |article|
      
      action = ""
      if can? :update, article
        action += link_to "Update", edit_article_path(article), :method=>"GET",:class=>"btn btn-xs btn-default"
      end
      if can? :destroy, article
        action += link_to "Delete", article_path(article), :method=>"DELETE","data-disable-with"=> "Wait..", "data-confirm"=>"delete this article ?", :class=>"btn btn-xs btn-danger"
      end

      [
        article.session,
        article.name,
        article.duration,
        action


        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
      ]
    end
  end

  def get_raw_records
    # insert query here


    advance_search = Article.all
    keyword = Article.full_search(params[:sSearch])

    if keyword == ":*"
      advance_search
    else
      advance_search.where("to_tsvector('simple',( SELECT CONCAT(articles.session,' ', articles.name ,' ', articles.duration ) )) @@ to_tsquery('simple','#{keyword}')")
    end


  end

  # ==== Insert 'presenter'-like methods below if necessary
end
