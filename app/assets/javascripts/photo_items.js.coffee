# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.api.photoItems =
    init: ->
        $('div#gallery-modal-meta-container, div#edit-photos div.edit-photo').on('change', 'input[type="checkbox"]', (event) ->
            event.stopPropagation()

            url = '/photo_items/toggle/' + $(this).data('photo-id') + '/' + this.id.replace('item-', '')

            $.getJSON url, (response) ->
                console.log response
        )

        togglePhotoItems = (event) ->
            event.preventDefault()

            $this = $(this)
            $this.find('i').toggleClass 'icon-angle-down icon-angle-up'

            if ( $('div#gallery-modal-meta-container').length )
                placeholder = $('div#gallery-modal-meta-container')
            else
                placeholder = $this.parents('div.edit-photo')

            container = placeholder.find('div.photo-items-settings')

            if container.data('populated')?
                container.slideToggle('fast')
            else
                $this.after('<i class="icon-spinner icon-spin"></i>')

                $.getJSON this.href, (response) ->
                    $this.next().remove()

                    container.data('populated', true).toggle(1, ->
                        container.html(response.entries).slideDown('fast')
                    )

        $('div#gallery-modal-meta-container').on 'click', 'a.photo-items-settings-toggler', togglePhotoItems
        $('div#edit-photos').on 'click', 'a.photo-items-settings-toggler', togglePhotoItems


