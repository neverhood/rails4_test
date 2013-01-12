# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.api.profiles = {
    container: -> $('div#profile-posts')
    url: -> @container().attr('data-url')

    currentPage: ->
        parseInt @container().attr('data-page')
    lastPage: ->
        @container().attr('data-last-page') == 'true'

    disableSubmit: (inputSelector, form) ->
        input = $( inputSelector )
        form.find('input[type="submit"]').attr('disabled', input.val().trim().length == 0)

    delayDisableSubmit: (form) ->
        setTimeout -> form.find('input[type="submit"]').attr('disabled', true)

    init: ->
        _this = this

        $.api.userAvatars.init() if $.api.isProfileOwner

        $.api.subscriptions.init() unless $.api.isProfileOwner
        $.api.conversations.init() unless $.api.isProfileOwner


        $('form#new-profile-post').bind('keyup.profiles', ->
            _this.disableSubmit('textarea#profile_post_body', $(this))
        ).bind('ajax:complete', (event, xhr, status) ->
            $this = $(this)
            response = $.parseJSON( xhr.responseText )

            $this.find('textarea#profile_post_body').val('')

            _this.container().prepend(response.post)
            _this.delayDisableSubmit $this
        ).
            find('input[type="submit"]').attr('disabled', true)

        $(document).
            bind('scroll.profiles', ->
                if $.api.loading or $.api.profiles.lastPage()
                    return false

                if nearBottomOfPage()
                    container   = _this.container()
                    pageToFetch = _this.currentPage() + 1
                    url         = "#{ _this.url() }?page=#{ pageToFetch }"

                    $.api.loading = true
                    $.getJSON url, (data) ->
                        container.append data.posts
                        container.attr('data-last-page', data.last)
                            .attr('data-page', pageToFetch)

                        $.api.loading = false
            ).
            bind('page:change', ->
                $(this).unbind '.profiles')

}
