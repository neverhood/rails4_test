$.api.newsFeedEntries = {
    container: -> $('div#news-feed')
    url: -> @container().attr('data-url')

    currentPage: ->
        parseInt @container().attr('data-page')
    lastPage: ->
        @container().attr('data-last-page') == 'true'

    init: ->
        $(document).bind('scroll.news-feed-entries', ->
            if $.api.loading or $.api.newsFeedEntries.lastPage()
                return false

            if nearBottomOfPage()
                container = $.api.newsFeedEntries.container()
                pageToFetch = $.api.newsFeedEntries.currentPage() + 1
                url = "#{ $.api.newsFeedEntries.url() }?page=#{ pageToFetch }"

                $.api.loading = true
                $.getJSON url, (data) ->
                    container.append data.entries
                    container.attr('data-last-page', data.last)
                        .attr('data-page', pageToFetch)

                    $.api.loading = false
        ).bind('page:change', ->
            $(this).unbind('.news-feed-entries')
        )

}
