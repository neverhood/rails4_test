# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.userDetails = {
    init: ->
        if $.api.action == 'edit'
            countriesMap = {}
            citiesMap = {}

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

            $('select#user_details_fake_country_id').bind 'change', ->
                $('input#user_details_country_id').val this.value

                if this.value == '0'
                    $this = $(this).hide()

                    input = $('input#country-auto-completion').show()
                    $this.parent().append input
                    input.focus()

            $('input#country-auto-completion').typeahead
                source: (query, process) ->
                    countriesMap = {}

                    $.getJSON("/countries?query=#{query}", (data) ->
                        objects = []
                        $.each(data.countries, (index, object) ->
                            countriesMap[object.name] = object
                            objects.push(object.name)
                        )

                        process objects
                    )

                updater: (item) ->
                    $('input#user_details_country_id').val countriesMap[item].id
                    item
}

