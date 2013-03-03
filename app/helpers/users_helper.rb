module UsersHelper
  def show_traffic(site, start_date, end_date)
    traffic = {}
    google_analytics = GA.new
    traffic['visitors'] = google_analytics.visitors(site.subdomain, start_date, end_date)
    traffic['taps'] = google_analytics.totalEvents(site.subdomain, start_date, end_date)
    traffic
  end
end
