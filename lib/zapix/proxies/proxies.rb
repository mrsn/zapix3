require_relative 'base'

class Proxies < Base
  def get_id(proxy_name)
    result = client.proxy_get('filter' => { 'host' => proxy_name })

    result.first['proxyid']
  end
end
