class IssuesController < ApplicationController
  inherit_resources

  respond_to to: :html, except: [:index]
  respond_to to: :json

  before_filter only: [:index, :show, :signatures] do 
    if request.format.json?
      check_mrdash_token
    end
  end
  before_filter { @current_page = "issue" }

  def index
    render json: collection
  end

  def archive
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

    @issues = collection.has_articles
    @issue  = resource 

    @articles = (@issue.petitions.where(:state => 'published') + @issue.petitions.where(:state => 'archived') + @issue.debates + @issue.personal_stories).sort{ |a, b| b.created_at <=> a.created_at }

    @article_count = @articles.length
    if !params[:page].nil? && params[:page].to_i > 1
      @page = params[:page].to_i
      @articles_start = (@page - 1) * 5
      article_end = (@page * 5) - 1
      @articles = @articles[@articles_start..article_end]
      if @articles.length == 5
        @articles_end = @articles_start + 5
      else
        @articles_end = @articles_start + @articles.length
      end
    else 
      @page = 1
      @articles = @articles.first(5)
      @article_count == 0 ? @articles_start = 0 : @articles_start = 1
      @articles_end = @articles.length
    end

    if request.xhr?
      render :json => {:articles => @articles, :issue => @issue, :start => @articles_start, :end => @articles_end, :count => @article_count, :page => @page }
    end
  end
end
