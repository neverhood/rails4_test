# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.photoComments = {
    container: -> $('div#comments')
    disableSubmit: (inputSelector, form) ->
        input = $( inputSelector )
        form.find('input[type="submit"]').attr('disabled', input.val().trim().length == 0)
    delayDisableSubmit: (form) ->
        setTimeout -> form.find('input[type="submit"]').attr('disabled', true)

    init: ->
        _this = this

        $.endlessScrolling
            namespace: 'photo-comments'
            container: 'div#comments'
            items:     'comments'


        $('form#new-photo-comment').bind('keyup.photo-comments', ->
            _this.disableSubmit('textarea#photo_comment_body', $(this))
        ).bind('ajax:complete', (event, xhr, status) ->
            $this = $(this)
            response = $.parseJSON( xhr.responseText )

            $this.find('textarea#photo_comment_body').val('')

            _this.container().prepend response.comment
            _this.delayDisableSubmit $this
        ).
            find('input[type="submit"]').attr('disabled', true)
}
