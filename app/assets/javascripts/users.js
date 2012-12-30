$(function() {
  // if the URL has query string in it, then we know this is first time
  // user's seeing the dashboard, bring up a welcome modal
  if(window.location.search != "") {
    var $subdomainStr = $('#subdomain');
    $subdomainStr.html(window.location.search.substring(11));
    $subdomainStr.parents('a').attr('href', 'http://'+$subdomainStr.html()+'.'+window.location.host);
    $('#welcomeModal').modal();
  }

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
  $('#mobile_screen > iframe').get(0).src = '/sites/'+ id + '?mobile=1'
}
