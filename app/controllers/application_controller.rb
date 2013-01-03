class ApplicationController < ActionController::Base
  helper_method :mobile_device?, :get_test_sites

  protect_from_forgery
  # SessionHelper resides in app/helpers/session_helper.rb
  # this is making all methods defined in SessionHelper available across controller and view
  include SessionsHelper

  private

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
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
