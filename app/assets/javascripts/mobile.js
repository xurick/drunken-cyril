var defaultBgColor = 'white';

$(document).delegate('.ui-page', 'pageinit', function () {

  // setting background for the entire page
  var bgcolor = $('.mdContent').css('background-color');
  if(bgcolor != 'transparent') {
    $(this).css('background', bgcolor); //'this' refers to '.ui-page'
  }
  else {
    $(this).css('background', defaultBgColor);
  }

  $.mobile.defaultPageTransition = "slide";
  $('img').error(function() {
    this.style.display = 'none';
  });

});

/*http://jsfiddle.net/budwhite/eKZLf/*/
$('#home').live('pageshow',function(){
  window.slider = new Swipe(document.getElementById('slider'));

  if($.cookie('switch_to_classic_popup') == null) {
    $.cookie('switch_to_classic_popup', 'foo', { expires: 7 });
    $('#switch_to_classic').popup({history:false});
    $('#switch_to_classic').popup('open', { x:0, y:0, transition:'slidedown' });
  }
});
