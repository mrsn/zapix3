require_relative 'base'
class Triggers < Base
  def create(options)
    client.trigger_create(options) unless exists?(options)
  end

  def delete(*trigger_ids)
    client.trigger_delete(trigger_ids)
  end

  # this is very unefficient
  # but there is no other way to verify that a trigger exists..
  def exists?(options)
    result = client.trigger_get('output' => 'extend',
                                'expandExpression' => true)

    id = extract_id(result, options['expression'])
    if id.nil?
      false
    else
      true
    end
  end

  def get_id(options)
    result = client.trigger_get('output' => 'extend',
                                'expandExpression' => true)
    id = extract_id(result, options['expression'])
    if id.nil?
      raise NonExistingTrigger, "Trigger with expression #{options['expression']} not found."
    else
      id
    end
  end

  class NonExistingTrigger < StandardError; end

  private

  def extract_id(triggers, expression)
    result = nil
    triggers.each do |trigger|
      if trigger['expression'] == expression
        result = trigger['triggerid']
        break
      end
    end
    result
  end
end
