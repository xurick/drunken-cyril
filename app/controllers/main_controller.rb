class MainController < ApplicationController
  helper_method :get_test_sites

  def home

    # creates a comment instance var to be used in the Contact us form
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.json do
        intent = params[:get]
        url = params[:url]

        case intent

        when 'markup'
          # dirty hack adding '/' because the DB url field is populated by using anchor.href
          # which automatically adds the '/'
          if current_user.sites && !current_user.sites.find_by_url(url+'/').nil?
            # this site already converted
            site = current_user.sites.find_by_url(url+'/')
            render :json => JSON.dump(site.id)
          else
            # no matching mobile sites yet
            markup_string = open(url).read
            if markup_string.encoding.name != 'UTF-8'
              markup_string.force_encoding('utf-8')
            end
            render :json => JSON.dump(markup_string)
          end

        when 'dcolor'
          #if Rails.env.development?
          Miro.options[:image_magick_path] = '/usr/local/bin/convert' if File.exists?('/usr/local/bin/convert')
          #end

          color_array = Miro::DominantColors.new(url).to_rgba

          # by default miro returns 8 dominant colors sorted by percentage
          # we return the first one if all of them are equally opaque
          # otherwise we return the most opaque, ie having greatest alpha value
          chosen_color = color_array.sort_by { |k| -k[3] }[0]

          logger.debug "color array: #{color_array}"
          logger.debug "chosen color: #{chosen_color}"

          render :json => JSON.dump({
            'red'=>chosen_color[0],
            'green'=>chosen_color[1],
            'blue'=>chosen_color[2]
          })

        when 'imgsize'
          size = FastImage.size(url)
          logger.debug size
          render :json => JSON.dump({
            'width' => size[0],
            'height' => size[1]
          })

        end
      end
    end
  end

  def test
    render :layout => 'mod'
  end

  def get_test_sites
    test_sites = %w{
      http://www.cafeoribellevue.com
      http://www.tresamigos.com
      http://www.havanamania.com
      http://www.restaurant-lebrouillarta.com
      http://www.serdas.com
      http://www.killermargaritas.com
      http://www.soffritto.com
      http://www.tazzacaffe.com
      http://ricenspicethai.com
      http://whatthepho.net
      http://www.phohoa.com
      http://www.anitascrepes.com
      http://www.lacreperievoila.com
      http://chengduchineserestaurant.com
      http://www.littleotterswim.com
      http://www.fosterharris.com
      http://www.aquaplasticsurgery.com
      http://www.hearstnonprofit.com/english/indexen.html
      http://www.lamppostpublishing.com
      http://www.cissecurity.ca
      http://www.425motorsports.com
      http://www.toptiercomputerservices.com
      http://www.tradingpub.com
      http://wilkinsmiller.com
      http://www.atisw.com
      http://www.justorthodontics.com
      http://www.lillypadvillage.com
      http://www.nickusborne.com
      http://www.ladeedogs.com
      http://www.jjsproperty.com
      http://www.gjawning.com
      http://www.uptempomagazine.com
      http://www.ecommonwealthbank.co
    }
  end
end
