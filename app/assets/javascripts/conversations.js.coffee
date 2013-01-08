
$.api.conversations = {

    disableSubmit: (inputSelector, form) ->
        input = $( inputSelector )
        form.find('input[type="submit"]').attr('disabled', input.val().trim().length == 0)

    delayDisableSubmit: (form) ->
        setTimeout -> form.find('input[type="submit"]').attr('disabled', true)

    scrollHistoryDown: ->
        if $('div#conversation').length
            history = $('div#conversation div#history')

            history.scrollTop( history[0].scrollHeight )

    currentPage: ->
        parseInt $('div#conversation').attr('data-page')
    lastPage: ->
        $('div#conversation').attr('data-last-page') == 'true'
    init: ->
        _this = this

        _this.scrollHistoryDown()
        $('body').scrollTop 10000

        $(document).bind 'page:change', ->
            $('div#history').unbind 'scroll'

        $('div#history').bind 'scroll', ->
            if $.api.loading or $.api.conversations.lastPage()
                return false

            if this.scrollTop < 400
                url = "/conversations/#{ $('div#conversation').attr('data-id') }?page=#{ $.api.conversations.currentPage() + 1 }"

                $.api.loading = true
                $.getJSON url, (data) ->
                    $('div#history').prepend data.groups

                    $.api.loading = false
                    conversation = $('div#conversation')
                    conversation.attr('data-page', $.api.conversations.currentPage() + 1)
                    conversation.attr('data-last-page', data.last)


        $('a#send-message').bind 'click', (event) ->
            event.preventDefault()
            event.stopPropagation()

            $('div#new-message-modal').modal('toggle')
            $('form#send-message input[type="submit"]').trigger 'keyup'

        $('form#send-message').bind('ajax:complete', (event, xhr, status) ->
            if status == 'success'
                response = $.parseJSON(xhr.responseText)
                $this = $(this)

                unless $this.find('input#message_conversation_id').length
                    $this.append("<input id='message_conversation_id' name='message[conversation_id]' type='hidden' value='#{response.conversation.id}' />")

                $('textarea#message_body').val('')
                $('div#new-message-modal').modal('hide')

                unless $('a#link-to-conversation').length
                    $('div#new-message-modal div.modal-footer').prepend response.conversation.url
        ).
            bind('keyup', ->
                _this.disableSubmit('textarea#message_body', $(this))
        ).
            find('input[type="submit"]').attr('disabled', true)

        $('form#new-conversation-message').
            bind('ajax:complete', (event, xhr, status) ->
                if status == 'success'
                    $this = $(this)
                    response = $.parseJSON(xhr.responseText)

                    if response.message.group
                        $('div#history').append response.message.body
                    else
                        $('div#history div.messages-group:last div.message:last').after response.message.body

                    $this.find('textarea').val ''
                    _this.scrollHistoryDown()
                    _this.delayDisableSubmit $this

            ).
            bind('keyup', ->
                _this.disableSubmit('textarea#message_body', $(this))
            ).
            find('input[type="submit"]').attr('disabled', true)

}

