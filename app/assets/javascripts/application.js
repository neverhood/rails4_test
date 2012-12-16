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
//= require underscore
//= require jquery_ujs
//= require turbolinks
//
//= require api/api
//
//= require users
//= require_self
//

$(document).on('ready page:load', function() {
    if ( typeof $.api.initialized  === 'undefined' ) {
        $.api.controller = this.body.id;
        $.api.action     = this.body.attributes['data-action'].value;

        if ( typeof $.api[ $.api.controller ] === 'object' ) $.api[ $.api.controller ].init();
        $.api.initialized = true
    }
});
