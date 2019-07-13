ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  value = event.duration
  name = "#{event.payload[:controller]}/#{event.payload[:action]}"

  StatService.instance.enqueue(name, { value: value })
  StatService.instance.enqueue(name, { count: 1 })
end
