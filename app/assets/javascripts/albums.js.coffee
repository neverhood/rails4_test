# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.api.albums = {
    delayDisableSubmit: (form) ->
        setTimeout -> form.find('input[type="submit"]').attr('disabled', true)

    init: ->
        _this = this

        $('a#new-album').bind 'click', (event) ->
            event.preventDefault()
            event.stopPropagation()

            $('div#new-album-modal').modal('show').
                find('input#album_name').focus()

        $('form#new-album').bind('ajax:complete', (event, xhr, status) ->
            response = $.parseJSON(xhr.responseText)

            if status == 'success'
                modal = $('div#new-album-modal')
                modal.modal('hide').find('input#album_name, textarea#album_description').val('')
                _this.delayDisableSubmit(modal)

                $('div#albums').prepend response.album
            else
                $('input#album_name').after("<span class='error-text'> #{ response.errors.name.join('<br />') } </span>")
        ).
            bind('ajax:beforeSend', ->
                $(this).find('span.error-text').remove()
            ).
            find('input#album_name').bind 'keyup', ->
                $('form#new-album input[type="submit"]').attr('disabled', this.value.trim().length == 0)

        $('div#albums').on 'hover', 'div.album', ->
            $(this).find('a.edit-album-link').toggleClass('hidden')
}
