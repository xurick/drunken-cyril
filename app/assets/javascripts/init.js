var mdot = (function(my, $) {

  $(function() {
    window.currentUserId = $('#current-userid').data('current-userid');

    $('.carousel').carousel({
      interval:5000
    });

    $('#action').click(function() {
      //if no current user, create a guest account
      var createUserResult;
      if(window.currentUserId === '') {
        createUserResult = $.post('/users', function(data) {
          // should get back the ID of the newly created guest user
          window.currentUserId = data
        });
      }

      var anchor = document.createElement('a');
      var url = $('#url_input').val();
      if(url == '') {
        alert('invalid url');
        return;
      }
      url = $.trim(url);
      url = mdot.util.smartAddUrlProtocol(url);
      if(!mdot.util.validateUrl(url)) {
        alert('invalid url');
        return;
      }

      anchor.href = url;
      $(this).text('Converting ...').toggleClass('loading disabled');
      var ifr = $('iframe.preview');
      if(ifr.length == 1) {
        ifr.animate({ opacity: 0.1 }, 1000);
        $('#mobile_screen').spin({color:'#fff', radius:40, length:30, lines:17, width:11, speed:1});
      }

      // get markup from arbitrary domains, side-stepping same-orig restriction by using jsonp
      // using 'when'..'then' because user needs to be created before we can assign site
      $.when(createUserResult).then(function() {
        $.ajax({
          url: '/main/home/',
          data: { 
            get: 'markup',
            url: url 
          },
          dataType: 'json',
        }).done(renderMarkup(anchor));
      }, function() {
        //TODO if createUserResult failed, what to do?
      });
    });
  });

  // http://stackoverflow.com/questions/939032/jquery-pass-more-parameters-into-callback
  function renderMarkup(anchor) {
    return function(markup) {
      if(/^\s*\d+\s*$/.test(markup)) { //if markup is a number
        var id = markup;
        if(window.location.pathname.indexOf('users') == -1) {//we are at home page
          window.location = 'users/' + window.currentUserId;
        }
        else {//we are already at dashboard, so highlight the row and switch preview
          var selector = "tr[id='row_" + id + "']";
          $(selector).click();
        }
      } else {

        // reset base href to load image sources that use relative URIs 
        // using regex: cannot use $.prepend because we don't have a DOM yet
        // the '?' is to make the matching lazy/non-greedy, ie matching the first '>'
        // it sees rather than the last
        var pat = /<head(.*?)>/gi, match = pat.exec(markup);

        // adding the <base> immediately after <head>
        if(match != null) {
          markup = markup.replace(pat, '<head ' +
              match[1] +
              '><base href=\'' +
              anchor.protocol +
              '//' +
              anchor.hostname +
              anchor.pathname + '\'  />');
        }
        else {//somehow <head> is not found, creates <head>
          pat = /<html(.*?)>/gi, match = pat.exec(markup);
          markup = markup.replace(pat, '<html ' +
              match[1] +
              '><head><base href=\'' +
              anchor.protocol +
              '//' +
              anchor.hostname +
              anchor.pathname + '\'  /></head>');
        }

        var desktopFrame = document.createElement('iframe');
        $(desktopFrame).addClass('preview hidden');
        $('.desktop .screen').append(desktopFrame);
        var desktopDoc = desktopFrame.contentWindow.document;
        desktopDoc.open();

        $(desktopFrame).load(function() {

          var mobilePage = mdot.mobilize(desktopDoc.body, anchor.href);
          mobilePage.url = anchor.href;
          mobilePage.phone = mdot.util.findPhone(desktopDoc);

          // create new site record
          $.post('/sites', mobilePage, function(data) {
            desktopFrame.parentNode.removeChild(desktopFrame);
            if(window.location.pathname.indexOf('users') == -1) {//we are at home page
              window.location = 'users/' + window.currentUserId + '?site_name=' + data.site_name;
            }
            else {//we are already at dashboard, so insert row and switch preview
              // data should be the id of the newly created site record
              
              var $subdomainStr = $('#subdomain');
              var host = window.location.host;
              host = (host.substr(0,4)==='www.') ? host.substr(4) : host;
              $subdomainStr.html(data.site_name);
              $subdomainStr.parents('a').attr('href', 'http://'+$subdomainStr.html()+'.'+host);
              $('#welcomeModal').modal();

              $('.table tr:last').after(newRowMarkup(data));
              var selector = "tr[id='row_" + data.site_id + "']";
              $(selector).click();
              $('a#action').text('Take action now!').toggleClass('loading disabled');
              $('iframe.preview').css('opacity', 1);
              $('#mobile_screen').spin(false);
            }
          });
        });
        desktopDoc.write(markup);
        desktopDoc.close();
      }
    }
  }

  function newRowMarkup(data) {
    var id = data.site_id;
    var name = data.site_name;
    var row_id = 'row_' + id;

    return '<tr id=' + row_id + '>' +
      "<td class='text-success'><strong>" + name + '</strong></td>' +
      "<td><a class='btn btn-success' href='/editor/" + id + "'><i class='icon-edit icon-white'></i> Edit</td>" +
      "<td><a class='btn btn-success' href='#'><i class='icon-globe icon-white'></i> Live</a></td>" +
      "<td><a class='btn btn-success' href='#'><i class='icon-facetime-video icon-white'></i> Traffic</a></td>" +
      "<td><a class='btn btn-danger' href='#'><i class='icon-trash icon-white'></i> Delete</a></td>" +
      "</tr>";
  }

  return my;

}(mdot || {}, jQuery));
