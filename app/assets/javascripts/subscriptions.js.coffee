# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$.api.subscriptions = {
    init: ->
        $('a#subscribe').bind 'ajax:complete', (event, xhr, status) ->
            if status == 'success'
                response = $.parseJSON( xhr.responseText )

                $(this).before( response.notification ).
                    remove()

        $('a#unsubscribe').bind 'ajax:complete', (event, xhr, status) ->
            if status == 'success'
                response = $.parseJSON( xhr.responseText )

                $(this).before( response.notification ).
                    remove()
}
