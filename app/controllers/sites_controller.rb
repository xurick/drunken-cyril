class SitesController < ApplicationController
  helper_method :make_map_url
  layout :mobile_or_not

  before_filter :signed_in_user, :except => [:show, :cafeori]

  def create
    @site = current_user.sites.build(
      :url => params[:url],
      :logo_img => params[:logo],
      :nav_menu => params[:menu],
      :content => params[:content],
      :subdomain => extract_name(params[:url]),
      :phone => params[:phone],
      :theme => 'd' # default theme TODO
    )
    #@site need to save first to have a site_id so that @address
    #can save as well
    if @site.save
      if params[:address]
        #don't care about @address save failure for now
        # TODO
        @address = @site.addresses.create(
          :street1 => params[:address][:street1],
          :street2 => params[:address][:street2],
          :city => params[:address][:city],
          :state => params[:address][:state],
          :zipcode => params[:address][:zip]
        )
      end
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

    if params.has_key?(:content) #via Mercury update
      site.logo_img = params[:content][:logo_img][:value]
      site.theme = params[:content][:md_theme][:value]

      if !params[:content][:buttons][:snippets].blank?
        snippets = params[:content][:buttons][:snippets]
        if !snippets[:snippet_0].nil?
          snippet_name = snippets[:snippet_0][:name]
        else
          snippet_name = snippets[:snippet_1][:name]
        end
        site.snippet = render_to_string(:file => "mercury/snippets/#{snippet_name}/preview", :layout => false)
      end

      #https://github.com/jejacks0n/mercury/issues/108
      content = params[:content][:site_content]
      if !content[:snippets].blank? #check if there are snippets, if yes, need to save
        dom = Nokogiri::HTML.parse(content[:value])
        snippet_name = content[:snippets][:snippet_0][:name]
        class_selector = '.' + snippet_name + '-snippet'
        dom.css(class_selector).each do |snippet|
          #somehow if we don't remove these two attributes, upon the next save the snippets
          #mysteriously disappeared! TODO
          snippet.attributes['data-snippet'].remove
          snippet.attributes['class'].remove
          snippet.inner_html = render_to_string(:file => "mercury/snippets/#{snippet_name}/preview", :layout => false)
        end

        content[:value] = dom.xpath('//body').inner_html
      end

      site.content = content[:value]

    elsif params.has_key?(:site) #update subdomain only via the golive dialog
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

  def cafeori
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
