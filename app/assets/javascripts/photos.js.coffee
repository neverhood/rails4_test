# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.api.photos = {
    allowedImageFormats: /(\.|\/)(gif|p?jpe?g|png)$/i,
    albumPhotosCount: -> $('div#album-photos div.photo').length,
    container: ->
        if $('div#album-photos').length then $('div#album-photos') else $('div#photos-container')
    editContainer: -> $('div#edit-photos')
    indexUrl: ->
        @container().data 'url'
    editUrl: ->
        @editContainer().data 'url'
    currentPage: (page) ->
        if not page? or page == 'show'
            parseInt @container().attr('data-page')
        else
            parseInt @editContainer().attr('data-page')
    lastPage: (page) ->
        if not page? or page == 'show'
            @container().attr('data-last-page') == 'true'
        else
            @editContainer().attr('data-last-page') == 'true'

    bindDescriptionUpdate: ->
        @editContainer().find('textarea.update-description').bind 'change', ->
            $this = $(this)
            $form = $this.parents('form')

            $form.find('div.success-text').fadeOut( -> $(this).remove() )

            $form.submit().
                append( "<div class='success-text'> #{ $this.data('notification') } </div>" )

            callback = ->
                $form.find('div.success-text').fadeOut( -> $(this).remove() )
            setTimeout callback, 2000
    bindAlbumIdUpdate: ->
        albumsData = $.parseJSON( $('div#available-albums').text() )
        albums = $.map( albumsData, (object) -> { text: object.name, value: object.id })

        @editContainer().find('a.choose-album').editable
            source: albums
            ajaxOptions: { type: 'put' }
    bindCoverUpdate: ->
        @editContainer().find('a.set-photo-as-cover').bind 'ajax:complete', (event, xhr, status) ->
            response = $.parseJSON(xhr.responseText)
            alert response.notification

    init: ->
        _this = this

        $.api.photoComments.init() if $.api.controller == 'photos' and $.api.action == 'show'

        $('form#upload-photos').fileupload
            dataType: 'json',
            maxFileSize: 5000000,
            done: (event, response) ->
                $.api.photos.container().prepend response.result.photo

                $('div#photo-uploading-container').find('#' + response.identifier ).remove()
                $('div.no-results').remove()
                $('span#current-images-count').text(parseInt( $('span#current-images-count').text() ) + 1)

            add: (event, data) ->
                file       = data.files[0]
                if _this.allowedImageFormats.test(file.type) or _this.allowedImageFormats.test(file.name)
                    identifier = "photo-upload-#{ new Date().getTime() }"

                    data.identifier = identifier
                    data.context = $('div#file-upload-progress').clone().attr('id', identifier).removeClass('hidden')
                    data.context.find('div.filename').text file.name

                    $('div#photo-uploading-container').append data.context

                    data.submit()
                else
                    alert "#{ file.name }: #{ $(this).data('alert') }"

            progress: (event, data) ->
                if data.context?
                    progress = parseInt( data.loaded/data.total * 100, 10 )
                    data.context.find('.bar').css
                        width: progress + '%'


        if ( $.api.controller == 'albums' and $.api.action == 'show' ) or ( $.api.controller == 'photos' and $.api.action == 'index' )

            $('div#album-photos, div#photos-container').bootstrapGallery
                containerSelector: 'div.photo',
                metaSelector: 'div.photo-meta',
                navigation: 'container',
                pagination: {
                    url: $.api.photos.indexUrl(),
                    pageParam: 'page',
                    perPage: 50,
                    loadOffset: 5, # fetch page when 'loadOffset' images left
                    lastPageIndicator: 'last', # check for 'lastPageIndicator' in response to verify if fetched page is the last one
                    lastPageDataAttribute: 'last-page', # will set the data-last-page to false or true
                    setPageDataAttribute: true
                },
                modal: {
                    selector: 'div#gallery-modal',
                    metaSelector: 'div#gallery-modal-meta-container',
                    imageContainer: 'div#gallery-modal-image',
                    outerContainer: 'div#gallery-modal-image-container',
                    indexSelector:  'span#current-image-index'
                }

            $(document).bind('scroll', ->
                if $.api.loading or $.api.photos.lastPage()
                    return false

                if nearBottomOfPage()
                    url = "#{ $.api.photos.indexUrl() }?page=#{ $.api.photos.currentPage() + 1 }"

                    $.api.loading = true
                    $.getJSON url, (data) ->
                        container = $.api.photos.container()
                        container.append data.photos
                        container.attr('data-last-page', data.last)
                            .attr('data-page', container.data('page') + 1)

                        $.api.loading = false
            ).bind('page:change', ->
                $(this).unbind('scroll')
            )

        if ( $.api.controller == 'albums' or $.api.controller == 'photos' ) and $.api.action == 'edit'
            $.api.photos.bindDescriptionUpdate()
            $.api.photos.bindAlbumIdUpdate()
            $.api.photos.bindCoverUpdate() if $.api.controller == 'albums'

            $('div#edit-photos div.edit-photo a.destroy-photo').bind('ajax:beforeSend', ->
                $(this).parents('div.edit-photo').remove()
            )
            # TODO: extract pagination
            $(document).bind('scroll.photos', ->
                if $.api.loading or $.api.photos.lastPage('edit')
                    return false

                if nearBottomOfPage()
                    url = "#{ $.api.photos.editUrl() }?page=#{ $.api.photos.currentPage('edit') + 1 }"

                    $.api.loading = true
                    $.getJSON url, (data) ->
                        container = $.api.photos.editContainer()
                        container.append data.entries
                        container.attr('data-last-page', data.last)
                            .attr('data-page', container.data('page') + 1)

                        $.api.photos.bindAlbumIdUpdate()
                        $.api.photos.bindDescriptionUpdate()

                        $.api.loading = false
            ).bind('page:change', ->
                $(this).unbind('.photos')
            )
}

