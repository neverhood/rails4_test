class CountriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    render json: { countries: Country.where(Country.arel_table[:name].matches("%#{ query }%")) }
  end

  private

  def query
    params[:query].present?? params[:query] : ''
  end
end
