class CitiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_country!

  def index
    @cities = query.present?? @country.cities.where(City.arel_table[:name].matches("%#{ query }%")) : @country.cities.large

    render json: { cities: @cities.to_json(only: [ :id, :name ]) }
  end

  private

  def query
    params[:query].present?? params[:query] : ''
  end

  def find_country!
    @country = Country.find_by(id: params[:id])

    render nothing: true if @country.nil?
  end
end
