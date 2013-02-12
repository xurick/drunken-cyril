module UsersHelper
  def show_traffic(site, start_date, end_date)
    google_analytics = GA.new
    google_analytics.visitors(site.subdomain, start_date, end_date)
  end
end
