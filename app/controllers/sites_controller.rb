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
      #render :text => @site.id.to_s
      render :json => { :site_id => @site.id, :site_name => @site.subdomain }
    else
      head :bad_request
    end
  end

  def show
    if request.subdomain.present? && request.subdomain != 'www'
      @site = Site.find_by_subdomain!(request.subdomain)
    else
      @site = current_user.sites.find(params[:id])
    end
  end

  def update
    site = current_user.sites.find(params[:id])
    site.logo_img = params[:content][:logo_img][:value]
    site.content = params[:content][:site_content][:value]
    site.save!
    render text: ''
  end

  def destroy
    current_user.sites.find(params[:id]).destroy
    flash[:success] = 'Website deleted.'
    redirect_to current_user
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
