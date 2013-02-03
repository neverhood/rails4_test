$.api.responseEntries = {
    container: -> $('div#response-entries')
    url: -> @container().attr('data-url')

    currentPage: ->
        parseInt @container().attr('data-page')
    lastPage: ->
        @container().attr('data-last-page') == 'true'

    init: ->
        $.endlessScrolling
            namespace: 'response-entries'
            container: 'div#response-entries'
            items:     'entries'
}

