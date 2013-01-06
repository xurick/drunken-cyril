class Subdomain
  def self.matches?(request)
    name = request.subdomain
    name != 'cafeori' && name.present? && name != 'www'
  end
end
