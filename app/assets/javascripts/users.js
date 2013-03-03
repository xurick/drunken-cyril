$(function() {
  // if the URL has query string in it, then we know this is first time
  // user's seeing the dashboard, bring up a welcome modal
  if(window.location.search != "") {
    var $subdomainStr = $('#subdomain');
    var host = window.location.host;
    host = (host.substr(0,4)==='www.') ? host.substr(4) : host;
    $subdomainStr.html(window.location.search.substring(11));
    $subdomainStr.parents('a').attr('href', 'http://'+$subdomainStr.html()+'.'+host);
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

  $(selector).last().click();

  var d = new Date(), start_date, end_date;
  d.setDate(new Date().getDate()-7);

  $("div[id^='trafficModal_']").each(function() {
    $(this).on('shown', function() {
      var id = this.id.slice(13); // getting the id number out of string 'trafficModal_XXX'
      $(this).find('.datepicker_from').datepicker('setDate', d).on('changeDate', function() {
        start_date = this.value;
      });
      $(this).find('.datepicker_to').datepicker({ todayBtn:'linked' }).datepicker('setValue').on('changeDate', function() {
        end_date = this.value;
      });
      var that = this;
      $(this).find('.update_date').click(function() {
        $.ajax({
          data: {
            site_id: id,
            start_date: start_date,
            end_date: end_date
          },
          dataType: 'json'
        }).done(function(data) {
          $(that).find('.visitors').html(data['visitors']);
          $(that).find('.taps').html(data['taps']);
        }).fail(function() {
          $(that).find('.visitors').html('0');
          $(that).find('.taps').html('0');
        });
        $(that).find('.visitors').html('querying ...');
        $(that).find('.taps').html('querying ...');
      });
      start_date = $(this).find('.datepicker_from').val();
      end_date = $(this).find('.datepicker_to').val();
    });
  });

});

function switchPreview(id) {
  $('#mobile_screen > iframe').get(0).src = '/sites/'+ id + '?mobile=1'
}
