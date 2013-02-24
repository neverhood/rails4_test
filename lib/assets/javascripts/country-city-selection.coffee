((($) ->
    settings = {
        citiesMap: {},
        countriesMap: {},
        citiesUrl: '/cities.json',
        countriesUrl: '/countries.json'
    }

    methods = {
        init: (options) ->
            $.extend settings, options

            settings.countrySelection = this
            settings.citySelection = $( options.citySelection )
            settings.cityId = $( options.cityId )
            settings.countryId = $( options.countryId )
            settings.cityAutoCompletion = $( options.cityAutoCompletion )
            settings.countryAutoCompletion = $( options.countryAutoCompletion )

            this.bind 'change', ->
                settings.countryId.val this.value
                methods.resetCities()

                if this.value == '0' # 'Other' selected, propose autocompletion
                    $this = $(this).hide()

                    $this.parent().append settings.countryAutoCompletion.show()
                    settings.countryAutoCompletion.focus()
                else if this.value.length != 0
                    methods.fetchAndAppendCities(this.value)

            settings.citySelection.bind 'change', ->
                settings.cityId.val this.value

                if this.value == '0'
                    $this = $(this).hide()

                    $this.parent().append settings.cityAutoCompletion.show()
                    settings.cityAutoCompletion.focus()

            settings.countryAutoCompletion.bind('keyup', ->
                methods.resetCities() if this.value.length == 0
            )

            settings.countryAutoCompletion.typeahead
                source: (query, process) ->
                    settings.countriesMap = {}
                    url = "#{settings.countriesUrl}?query=#{query}"

                    $.getJSON(url, (data) ->
                        objects = []
                        $.each(data.countries, (index, object) ->
                            settings.countriesMap[object.name] = object
                            objects.push(object.name)
                        )

                        process objects
                    )

                updater: (item) ->
                    countryId = settings.countriesMap[item].id

                    methods.resetCities()
                    methods.fetchAndAppendCities(countryId)

                    settings.countryId.val countryId
                    item

            settings.cityAutoCompletion.typeahead
                source: (query, process) ->
                    settings.citiesMap = {}
                    countryId = settings.countryId.val()
                    url = "#{settings.citiesUrl}?id=#{countryId}&query=#{query}"

                    $.getJSON(url, (data) ->
                        objects = []
                        $.each($.parseJSON(data.cities), (index, object) ->
                            settings.citiesMap[object.name] = object
                            objects.push(object.name)
                        )

                        process objects
                    )

                updater: (item) ->
                    settings.cityId.val settings.citiesMap[item].id
                    item


        resetCities: ->
            settings.citySelection.find('option:gt(0)').remove()

            if settings.cityAutoCompletion.is(':visible')
                settings.cityAutoCompletion.val('').hide()
                settings.citySelection.show()

        resetCountries: ->
            methods.resetCities()

            settings.countryAutoCompletion.val('').hide()
            settings.countrySelection.show()

        fetchAndAppendCities: (countryId, query) ->
            url = "/cities.json?id=#{countryId}"
            url += "&query=#{query}" if query?

            $.getJSON(url, (data) ->
                cities = $.map( $.parseJSON(data.cities), (city) ->
                    "<option value='#{city.id}'> #{ city.name } </option>" )

                settings.citySelection.append(cities)
                settings.citySelection.append "<option value='0'> Другой.. </option>"
            )

    }

    $.fn.countryCitySelection = (method) ->
        if method.constructor is Object or not method? # options or null passed, pass to init
            methods.init.apply this, arguments
        else if methods[method]? # existing method called
            methods[method].apply this, Array.prototype.slice.call(arguments, 1)
        else
            $.errors "countryCitySelection does not have a method #{ method }"


))(jQuery)
