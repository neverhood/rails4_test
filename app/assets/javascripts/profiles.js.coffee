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

            _this.container().prepend(response.post).find('h3#no-profile-posts').remove()
            _this.delayDisableSubmit $this
        ).
            find('input[type="submit"]').attr('disabled', true)

        $.endlessScrolling
            namespace: 'profiles'
            container: 'div#profile-posts'
            items:     'posts'

}
