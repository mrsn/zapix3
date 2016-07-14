require_relative 'base'

class ScreenItems < Base
  def create(options)
    client.screenitem_create(options)
  end

  def delete(*screen_items_ids)
    client.screenitem_delete(screen_items_ids)
  end
end
