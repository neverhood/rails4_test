// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.remotipart
//= require underscore
//= require jquery_ujs
//= require turbolinks
//= require jquery-fileupload/basic
//
//= require bootstrap
//= require bootstrap-gallery
//= require editable
//= require editable-rails
//
//= require api/api
//
//= require users
//= require user_details
//= require user_avatars
//= require subscriptions
//= require conversations
//= require albums
//= require photos
//= require news_feed_entries
//= require profiles
//= require welcome
//= require_self
//

$.ajaxSettings.dataType = 'json';

function nearBottomOfPage() {
    return scrollDistanceFromBottom() < 400;
}

function scrollDistanceFromBottom() {
    return pageHeight() - (window.pageYOffset + window.innerHeight);
}

function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

$(document).on('ready page:load', function() {
    $.api.controller     = this.body.id;
    $.api.action         = this.body.attributes['data-action'].value;
    $.api.isProfileOwner = this.body.attributes['data-profile-owner'].value === 'true';

    if ( $('div#current-user-json').length )
        $.api.currentUser = $.parseJSON( $('div#current-user-json') )

    if ( typeof $.api[ $.camelCase($.api.controller) ] === 'object' ) $.api[ $.camelCase($.api.controller) ].init();

    $.api.loading = false
});
