require_relative 'base'

class Proxies < Base

  def get_id(options)
    result = client.proxies_get({
      'filter' => {'name' => options['name']}})
      result.first['proxyid']
  end

end