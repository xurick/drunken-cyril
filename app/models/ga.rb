#http://gistflow.com/posts/398-pageviews-for-posts
class GA
  extend Garb::Model

  metrics :visitors, :total_events
  dimensions :hostname

  attr_reader :profile

  def initialize
    Garb::Session.login(
      Figaro.env.ga_login,
      Figaro.env.ga_password
    )

    @profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == Figaro.env.ga_web_property_id}
  end

  #https://github.com/bbatsov/ruby-style-guide/issues/73
  def visitors(subdomain, start_date, end_date)
    GA.results(
      profile,
      :filters => { :hostname.contains => "^#{subdomain}\.mbilify\.com$" },
      :start_date => start_date,
      :end_date => end_date
    ).to_a.first.try(:visitors)
  end

  def totalEvents(subdomain, start_date, end_date)
    GA.results(
      profile,
      :filters => { :hostname.contains => "^#{subdomain}\.mbilify\.com$" },
      :start_date => start_date,
      :end_date => end_date
    ).to_a.first.try(:total_events)
  end
end
