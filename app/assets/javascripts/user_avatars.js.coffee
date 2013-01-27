# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jcrop
#

$.api.userAvatars = {
    initJcrop: ->
        jcropUpdatePreview = (coords) ->
            croppedImage = $('img#user-avatar-thumb')
            originalImage = $('img#croppable-user-avatar')
            rx = 100 / coords.w
            ry = 100 / coords.h

            croppedImage.css
                width: Math.round(rx * originalImage.width()) + 'px'
                height: Math.round(ry * originalImage.height()) + 'px'
                marginLeft: '-' + Math.round(rx * coords.x) + 'px'
                marginTop: '-' + Math.round(ry * coords.y) + 'px'

        jcropUpdateInputs = (coords) ->
            $('input#user_crop_x').val coords.x
            $('input#user_crop_y').val coords.y
            $('input#user_crop_h').val coords.h
            $('input#user_crop_w').val coords.w
            jcropUpdatePreview(coords)


        $.Jcrop('img#croppable-user-avatar', {
            aspectRatio: 1,
            setSelect:   [0,0,600,600],
            onSelect: jcropUpdateInputs,
            onChange: jcropUpdateInputs
        })

    init: ->
        _this = this
        jcrop = null

        updateAvatarModal = $('div#upload-new-photo-modal')
        cropAvatarModal = $('div#crop-photo-modal').bind 'hidden', ->
            jcrop.destroy()

        # Toggle new-photo-modal
        $('a#upload-new-photo').bind 'click', (event) ->
            event.stopPropagation()
            event.preventDefault()

            updateAvatarModal.modal('toggle')

        $('a#crop-photo').bind 'click', (event) ->
            event.stopPropagation()
            event.preventDefault()

            jcrop = _this.initJcrop()
            cropAvatarModal.modal('toggle')

        # new-photo-modal preview
        $('input#user_avatar').change (event) ->
            files  = if this.files then this.files else this.currentTarget.files

            if files and files[0]
                reader = new FileReader

                reader.onload = (event) ->
                    preview = $('div#new-photo-preview')
                    preview.find('img').remove()
                    preview.append( "<img src='" + event.target.result + "' />" )

                reader.readAsDataURL files[0]

        $('form#new-user-avatar').bind 'ajax:complete', (event, xhr, status) ->
            alert 'why'
            $('div#upload-new-photo-modal').modal('hide')
            avatarContainer = $('div#profile-avatar')

            response = $.parseJSON( xhr.responseText )
            avatarContainer.find('img').attr('src', response.image.medium)
            $('img#croppable-user-avatar').attr('src', response.image.medium)
            $('img#user-avatar-thumb').attr('src', response.image.medium)

            $('a#crop-photo, a#delete-user-avatar').removeClass('hidden')

        $('form#crop-user-avatar').bind 'ajax:complete', (event, xhr, status) ->
            $('div#crop-photo-modal').modal('hide')

        $('a#delete-user-avatar').bind 'ajax:complete', (event, xhr, status) ->
            response = $.parseJSON( xhr.responseText )

            $('div#profile-avatar').find('img').attr('src', response.image.medium)

            $('a#crop-photo, a#delete-user-avatar').addClass('hidden')

}
