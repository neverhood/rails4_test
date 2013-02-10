module UserDetailsHelper
  def countries_collection
    Country.general.push OpenStruct.new(id: 0, name: t('.other_country'))
  end
end
