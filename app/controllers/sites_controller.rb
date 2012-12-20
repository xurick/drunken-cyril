class SitesController < ApplicationController
  layout 'mobile'

  before_filter :signed_in_user, :except => :test

  def create
    @site = current_user.sites.build(
      :url => params[:url],
      :logo_img => params[:logo],
      :nav_menu => params[:menu],
      :content => params[:content]
    )

    if @site.save
      head :ok
    else
      head :bad_request
    end
  end

  def show
    url = session[:current_url]
    if url.nil?
      head :not_found
    else
      @site = current_user.sites.find_by_url(url+'/')
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
end
