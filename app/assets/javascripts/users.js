$(function() {
  var selector = 'tr[id*="row"]';

  $(document).on('click', selector, function() {
  //$(selector).live('click', function() {
    if(!$(this).hasClass('warning')) {
      $(this).addClass('warning');
      $(this).siblings('.warning').removeClass('warning');
      switchPreview(this.id.substr(4));
    }
  });

  $(selector).first().click();
});

function switchPreview(id) {
  $('#mobile_screen > iframe').get(0).src = '/sites/'+id
}
