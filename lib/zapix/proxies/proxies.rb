require_relative 'base'

class Proxies < Base

  def get_id(name)
    result = client.proxy_get({
      'filter' => {'name' => name}})
      result.first['proxyid']
  end

end