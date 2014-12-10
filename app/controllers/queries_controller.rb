class QueriesController < ApplicationController
  before_action :set_query, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @queries = Query.all
    respond_with(@queries)
  end

  def show
    respond_with(@query)
  end

  def new
    @query = Query.new
    respond_with(@query)
  end

  def edit
  end

  def create
    @query = Query.new(query_params)
    @query.save
    respond_with(@query)
  end

  def update
    @query.update(query_params)
    respond_with(@query)
  end

  def destroy
    @query.destroy
    respond_with(@query)
  end

  private
    def set_query
      @query = Query.find(params[:id])
    end

    def query_params
      params.require(:query).permit(:user_id, :query_content)
    end
end
