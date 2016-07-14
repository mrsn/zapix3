require_relative 'base'

class Screens < Base
  def get_id(options)
    result = client.screen_get({
      'filter' => {'name' => options['name']}
    })

    result.first['screenid']
  end

  def create(options)
    client.screen_create(options) unless exists?(options)
  end

  def delete(*screen_ids)
    client.screen_delete(screen_ids)
  end

  def exists?(options)
    result = client.screen_get({'filter' => {'name' => options['name']}})
    if (result == nil || result.empty?)
      false
    else
      true
    end
  end
end
