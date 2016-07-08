require_relative 'base'

class Proxies < Base

  def get_id(options)
    result = client.action_get({
      'filter' => {'name' => options['name']}})
      result.first['proxyid']
  end

end