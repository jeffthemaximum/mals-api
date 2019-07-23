class IpLocationService < ApplicationService
  include MaxMindDB
  @@db = MaxMindDB.new(File.join(Rails.root, 'app', 'services', 'geoip2.mmdb'))

  def initialize(ip_address)
    @ip_address = ip_address
  end

  def call
    @@db.lookup(@ip_address)
  end
end
