// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.url
//= require jquery.spin
//= require jquery.countdown
//= require bootstrap
//= require bootstrap-datepicker
//= require theme
//= require init
//= require util
//= require walk
//= require sites
//= require users

// from http://lesseverything.com/blog/archives/2012/07/18/customizing-confirmation-dialog-in-rails/
// overriding default Rails handling of confirm dialog
$(function() {
  // has to write or bootstrap tooltip will not work everywhere
  $("[rel='tooltip']").tooltip();

  $.rails.allowAction = function(link) {
    if (!link.attr('data-confirm')) {
      return true;
    }
    $.rails.showConfirmDialog(link);
    return false;
  };

  $.rails.confirmed = function(link) {
    link.removeAttr('data-confirm');
    return link.trigger('click.rails');
  };

  $.rails.showConfirmDialog = function(link) {
    var modalHtml, sitename;
    sitename = link.attr('data-confirm');
    modalHtml = $('#confirmDeleteModal');
    modalHtml.find('span#site_name').html(sitename);
    $(modalHtml).modal();
    return $('#confirmDeleteModal .confirm').on('click', function() {
      return $.rails.confirmed(link);
    });
  };
});
