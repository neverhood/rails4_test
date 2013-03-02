$.api.usersSearch = {
    init: ->
        typingInterval = null
        doneTypingInterval = 200

        $('select#users_search_fake_country_id').countryCitySelection
            cityId:                'input#users_search_city_id',
            countryId:             'input#users_search_country_id',
            citySelection:         'select#users_search_fake_city_id',
            cityAutoCompletion:    'input#city-auto-completion',
            countryAutoCompletion: 'input#country-auto-completion',
            citiesUrl:             '/cities.json',
            countriesUrl:          '/countries.json'


        $('input#users_search_name').bind('keyup', ->
            $this = $(this)

            if $this.val().length == 0
                $('div#users-search-results').html "<span class='tip'> #{ $('form#users-search').data('placeholder-text') } </span>"
                $('h3#search-results-count').hide()
                $this.data('value', '')
                clearTimeout(typingInterval)

                return false

            if typeof $this.data('value') == 'undefined' or $this.data('value') != $this.val()
                $this.data('value', $this.val())

                clearTimeout(typingInterval)

                callback = ->
                    $this.parents('form').submit()

                typingInterval = setTimeout callback, doneTypingInterval
        )

        $('input#users_search_male_true, input#users_search_male_false, input#users_search_country_id, input#users_search_city_id').
            bind('change', -> $(this).parents('form').submit())

        $('form#users-search').bind('ajax:complete', (event, xhr, status) ->
            response = $.parseJSON(xhr.responseText)

            if response.total > 0
                $('div#users-search-results').html response.users

                $('strong#users-search-results-total').html response.total
                $('h3#search-results-count').show()
            else
                $('div#users-search-results').html "<span class='tip'> #{ $(this).data('placeholder-text') } </span>"
                $('h3#search-results-count').hide()
        )

}
