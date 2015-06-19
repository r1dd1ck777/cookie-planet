//= require underscore
//= require jquery
//= require jquery_ujs
//= require jquery/jquery.localstorage.js
//= require lightbox
//= require ckeditor/init
// require ckeditor/config.js
//= require turbolinks
//= require select2
//= require bootstrap
//= require angular
//= require angular-local-storage
//= require angular-ui-select2
//= require google-analytics-turbolinks

'use strict';

CKEDITOR.disableAutoInline = true;

Math.round_to = function(v, to){
    var coof = Math.pow(10,to);
    return Math.round(v * coof) / coof
}

