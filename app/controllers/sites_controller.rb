class SitesController < ApplicationController
  layout 'mobile'

  before_filter :signed_in_user, :except => [:show, :test]

  def create
    @site = current_user.sites.build(
      :url => params[:url],
      :logo_img => params[:logo],
      :nav_menu => params[:menu],
      :content => params[:content],
      :subdomain => extract_name(params[:url])
    )

    if @site.save
      head :ok
    else
      head :bad_request
    end
  end

  def show
    if request.subdomain.present? && request.subdomain != 'www'
      @site = Site.find_by_subdomain!(request.subdomain)
    else
      url = session[:current_url]
      if url.nil?
        head :not_found
      else
        @site = current_user.sites.find_by_url(url+'/')
      end
    end
  end

  def update
    url = session[:current_url]
    if url.nil?
      head :not_found
    else
      site = current_user.sites.find_by_url(url+'/')
      site.logo_img = params[:content][:logo_img][:value]
      site.content = params[:content][:site_content][:value]
      site.save!
      render text: ''
    end
  end

  def test
    render :layout => false
  end

  private

  def extract_name(url)
    host = URI.parse(url).host
    parts = host.split('.')
    return host.start_with?('www') ? parts[1] : parts[0]
  end

end
