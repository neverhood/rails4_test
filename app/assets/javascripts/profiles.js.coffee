# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.api.profiles = {
    init: ->
        $.api.userAvatars.init() if $.api.isProfileOwner
        $.api.newsFeedEntries.init() if $.api.isProfileOwner

        $.api.subscriptions.init() unless $.api.isProfileOwner
        $.api.conversations.init() unless $.api.isProfileOwner
}
