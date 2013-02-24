module UserDetailsHelper
  def countries_collection
    Country.general.push(OpenStruct.new(id: 0, name: t('.other_country'))).tap do |countries|
      countries.unshift current_user.country if current_user.details['country_id'].present?
    end.uniq
  end

  def cities_collection
    if current_user.details['country_id'].present? and current_user.details['city_id'].present?
      (Array(current_user.city) + current_user.country.cities.large).push OpenStruct.new(id: 0, name: t('.other_city'))
    else
      []
    end.uniq
  end
end
