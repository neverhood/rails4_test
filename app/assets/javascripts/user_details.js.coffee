# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.userDetails = {
    init: ->
        if $.api.action == 'edit'
            countriesMap = {}
            citiesMap    = {}

            currentLoginContainer = $('span#current-login')
            currentLoginContainer.data('placeholder', currentLoginContainer.text())

            $('input#user_login').bind 'keyup', ->
                if this.value.length > 0
                    currentLoginContainer.text( this.value )

                    if /^[A-Za-z]+[_-]*[A-Za-z]+$/.test(this.value)
                        currentLoginContainer.removeClass('error-text')
                    else
                        currentLoginContainer.addClass('error-text')
                else
                    currentLoginContainer.text currentLoginContainer.data('placeholder')

            $('select#user_details_fake_country_id').countryCitySelection
                cityId:                'input#user_details_city_id',
                countryId:             'input#user_details_country_id',
                citySelection:         'select#user_details_fake_city_id',
                cityAutoCompletion:    'input#city-auto-completion',
                countryAutoCompletion: 'input#country-auto-completion',
                citiesUrl:             '/cities.json',
                countriesUrl:          '/countries.json'


}

