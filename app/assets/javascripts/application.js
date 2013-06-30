// listed below.
// This is a manifest file that'll be compiled into application.js, which will include all the files
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
//= require underscore
//= require jquery_ujs
//= require turbolinks
//= require jquery-fileupload/basic
//
//= require bootstrap-transition
//= require bootstrap-alert
//= require bootstrap-modal
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-typeahead
//
//= require bootstrap-modal-extended
//= require bootstrap-modalmanager
//= require bootstrap-gallery
//= require bootstrap-typeahead
//= require endless-scrolling
//= require country-city-selection
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
//= require response_entries
//= require photo_comments
//= require photo_items
//= require profiles
//= require users_search
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

function scrollDistanceFromTop() {
}

function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

$(document).on('ready page:load', function() {
    var backToTop = $('div#back-to-top');
    var $window = $(window);

    $(this).bind('scroll', function() {

        if ( $window.scrollTop() > 500 )
            backToTop.show();
        else
            backToTop.hide();

        if ( typeof backToTop.data('enlarged') === 'undefined' ) {
            backToTop.css('height', backToTop.offset().height + $('div#header').height());
            backToTop.data('enlarged', true);
        }
    });

    backToTop.bind('click', function() {
        window.scrollTo(0);
    });

    $.api.controller     = this.body.id;
    $.api.action         = this.body.attributes['data-action'].value;
    $.api.isProfileOwner = this.body.attributes['data-profile-owner'].value === 'true';

    if ( $('div#current-user-json').length )
        $.api.currentUser = $.parseJSON( $('div#current-user-json').text() )
    if ( $('div#user-json').length )
        $.api.user = $.parseJSON( $('div#user-json').text() )

    if ( typeof $.api[ $.camelCase($.api.controller) ] === 'object' ) $.api[ $.camelCase($.api.controller) ].init();

    $.api.loading = false
});
