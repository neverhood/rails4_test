$.api.newsFeedEntries = {
    container: -> $('div#news-feed')
    url: -> @container().attr('data-url')

    currentPage: ->
        parseInt @container().attr('data-page')
    lastPage: ->
        @container().attr('data-last-page') == 'true'

    init: ->
        $.endlessScrolling
            namespace: 'news-feed-entries'
            container: 'div#news-feed'
            items:     'entries'
}

