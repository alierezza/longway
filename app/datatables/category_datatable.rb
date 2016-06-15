class CategoryDatatable < AjaxDatatablesRails::Base
  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  include AjaxDatatablesRails::Extensions::Kaminari
  # include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator

  def_delegators :@view, :link_to ,:can?, :categories_path, :category_path, :edit_category_path

  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @sortable_columns ||= ['categories.name']
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |category|

      action = ""
      if can? :update, category
        action += link_to "Update", edit_category_path(category), :method=>"GET",:class=>"btn btn-xs btn-default"
      end
      if can? :destroy, category
        action += link_to "Delete", category_path(category), :method=>"DELETE","data-disable-with"=> "Wait..", "data-confirm"=>"delete this category ?", :class=>"btn btn-xs btn-danger"
      end
      
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        category.name,
        action
      ]
    end
  end

  def get_raw_records
    # insert query here

    advance_search = Category.all
    keyword = Home.full_search(params[:sSearch])

    if keyword == ":*"
      advance_search
    else
      advance_search.where("to_tsvector('simple',( SELECT CONCAT(categories.name ) )) @@ to_tsquery('simple','#{keyword}')")
    end

  end

  # ==== Insert 'presenter'-like methods below if necessary
end
