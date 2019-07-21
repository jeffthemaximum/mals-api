ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  value = event.duration
  base_name = "#{event.payload[:controller]}/#{event.payload[:action]}"

  StatService.instance.enqueue(base_name, { value: value })

  if (event.payload[:status] < 300)
    count_name = "#{base_name}/success"
  else
    count_name = "#{base_name}/error"
  end

  StatService.instance.enqueue(count_name, { count: 1 })
end
