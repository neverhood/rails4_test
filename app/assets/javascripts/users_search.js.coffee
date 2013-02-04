$.api.usersSearch = {
    init: ->
        typingInterval = null
        doneTypingInterval = 500

        $('input#users_search_name').bind('keyup', ->
            $this = $(this)

            if typeof $this.data('value') == 'undefined' or $this.data('value') != $this.val()
                $this.data('value', $this.val())

                clearTimeout(typingInterval)

                typingInterval = setTimeout(
                    ( -> $this.parents('form').submit() ), doneTypingInterval
                )
        )

        $('form#users-search').bind('change', ->
            $(this).submit()
        ).bind('ajax:complete', (event, xhr, status) ->
            response = $.parseJSON(xhr.responseText)

            if response.total > 0
                $('div#users-search-results').html response.users

                $('strong#users-search-results-total').html response.total
                $('div#search-results-count').show()
            else
                $('div#users-search-results').html "<span class='tip'> #{ $(this).data('placeholder-text') } </span>"
                $('div#search-results-count').hide()
        )

}
