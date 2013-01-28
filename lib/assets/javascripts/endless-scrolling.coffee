((($) ->
    settings = {}

    methods = {
        init: (options) ->
            settings = options

            $(document).
                bind("scroll.#{ options.namespace }", ->
                    return false if $.api.loading or methods.lastPage()

                    methods.fetch() if methods.nearBottomOfPage()
                ).
                bind('page:change', ->
                    $(this).unbind ".#{ options.namespace }")

        fetch: ->
            $.api.loading = true
            $.getJSON methods.nextPageUrl(), (data) ->
                methods.container().attr('data-last-page', data.last)
                    .attr('data-page', methods.currentPage() + 1)
                methods.container().append(data[settings.items])

                $.api.loading = false

        container: ->
            $( settings.container )
        lastPage: ->
            methods.container().attr('data-last-page') == 'true'
        currentPage: ->
            parseInt methods.container().attr('data-page')
        url: ->
            methods.container().attr('data-url')
        nextPageUrl: ->
            "#{ methods.url() }?page=#{ methods.currentPage() + 1 }"
        nearBottomOfPage: ->
            scrollDistanceFromBottom() < 400

    }

    $.endlessScrolling = (method) ->
        if method.constructor is Object or not method? # options or null passed, pass to init
            methods.init.apply this, arguments
        else if methods[method]? # existing method called
            methods[method].apply this, Array.prototype.slice.call(arguments, 1)
        else
            $.errors "endlessScrolling does not have a method #{ method }"

))(jQuery)
