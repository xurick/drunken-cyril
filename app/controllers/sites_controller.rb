class SitesController < ApplicationController
  helper_method :make_map_url
  layout :mobile_or_not

  before_filter :signed_in_user, :except => [:show, :test]

  def create
    @site = current_user.sites.build(
      :url => params[:url],
      :logo_img => params[:logo],
      :nav_menu => params[:menu],
      :content => params[:content],
      :subdomain => extract_name(params[:url]),
      :phone => params[:phone] 
    )
    if @site.save
      if params[:address]
        @address = @site.addresses.build(
          :street1 => params[:address][:street1],
          :street2 => params[:address][:street2],
          :city => params[:address][:city],
          :state => params[:address][:state],
          :zipcode => params[:address][:zip]
        )
        if @address.save
          render :json => { :site_id => @site.id, :site_name => @site.subdomain }
        else
          head :bad_request
        end
      end
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
    if params.has_key?(:content)
      site.logo_img = params[:content][:logo_img][:value]
      site.content = params[:content][:site_content][:value]
    elsif params.has_key?(:site)
      site.subdomain = params[:site][:subdomain]
    end
    site.save!
    # passing the current user ID to JS to redirect back to dashboard
    render text: current_user.id.to_s
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

  def mobile_or_not
    if params[:mobile] || mobile_device?
      'mobile'
    else
      'mod'
    end
  end

  def make_map_url(record)
    if record
      addr_str = "#{record.street1} #{record.street2} #{record.city} #{record.state} #{record.zipcode}"
      return 'http://maps.google.com/maps?q='+URI.escape(addr_str)+'&output=embed'
    else
      return '#'
    end
  end
end
