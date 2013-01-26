module ApplicationHelper

  #https://gist.github.com/818065
  #https://github.com/rails/rails/issues/7320 needs to call html_escape to prevent
  # Rails3 mandatory escaping 
  def google_analytics_js(id = null)

    content_tag(:script, :type => 'text/javascript') do
      "var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '#{id}']);
      _gaq.push(['_setDomainName', 'mbilify.com']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();".html_safe
    end if !id.blank? && Rails.env.production?

  end
end
