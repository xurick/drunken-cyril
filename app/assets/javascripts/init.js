var mdot = (function(my, $) {

  $(function() {
    window.currentUserId = $('#current-userid').data('current-userid');

    $('.carousel').carousel({
      interval:5000
    });

    $('#action').click(function() {
      //if no current user, create a guest account
      if(window.currentUserId === '') {
        $.post('/users', function(data) {
          // should get back the ID of the newly created guest user
          // TODO if data is empty, guest user creation fails, what to do
          window.currentUserId = data
        });
      }

      var anchor = document.createElement('a');
      var url = $('#url_input').val();
      anchor.href = url;
      $(this).toggleClass('loading disabled');
      // get markup from arbitrary domains, side-stepping same-orig restriction by using jsonp
      $.ajax({
        data: { 
          get: 'markup',
          url: url 
        },
        dataType: 'json',
      }).done(renderMarkup(anchor));
    });
  });

  // http://stackoverflow.com/questions/939032/jquery-pass-more-parameters-into-callback
  function renderMarkup(anchor) {
    return function(markup) {
      if(markup == '') {
        if(markup == '') {
          window.location = 'users/' + window.currentUserId;
        }
      } else {

        // reset base href to load image sources that use relative URIs 
        // using regex: cannot use $.prepend because we don't have a DOM yet
        // the '?' is to make the matching lazy/non-greedy, ie matching the first '>'
        // it sees rather than the last
        var pat = /<head(.*?)>/gi, match = pat.exec(markup);

        // adding the <base> immediately after <head>
        markup = markup.replace(pat, '<head ' +
            match[1] +
            '><base href=\'' +
            anchor.protocol +
            '//' +
            anchor.hostname +
            anchor.pathname + '\'  />');

        var desktopFrame = document.createElement('iframe');
        $(desktopFrame).addClass('preview hidden');
        $('.desktop .screen').append(desktopFrame);
        var desktopDoc = desktopFrame.contentWindow.document;
        desktopDoc.open();
        $(desktopFrame).load(function() {
          var mobilePage = mdot.mobilize(desktopDoc.body);
          mobilePage.url = anchor.href;
          $.post('sites/create', mobilePage, function() {
            desktopFrame.parentNode.removeChild(desktopFrame);
            window.location = 'users/' + window.currentUserId;

          });
        });
        desktopDoc.write(markup);
        desktopDoc.close();
      }
    }
  }

  return my;

}(mdot || {}, jQuery));
