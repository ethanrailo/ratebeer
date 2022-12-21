class WeatherstackApi
  def self.weather_in(city)
    city = "weather_#{city.downcase}"
    Rails.cache.fetch(city, expires_in: 1.hour) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    return [] if response["success"] == false

    response
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise "WEATHERSTACK_APIKEY env variable not defined" if ENV["WEATHERSTACK_APIKEY"].nil?

    ENV.fetch("WEATHERSTACK_APIKEY")
  end
end
