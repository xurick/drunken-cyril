module ApplicationHelper

  #https://gist.github.com/818065
  def google_analytics_js

    content_tag(:script, :type => 'text/javascript') do
      "var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-37983247-1']);
      _gaq.push(['_setDomainName', 'mbilify.com']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();"
    end if Rails.env.production?

  end
end
